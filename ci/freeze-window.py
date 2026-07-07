import argparse
import datetime
import logging
import os
import sys

import pydantic
import yaml

FREEZE_WINDOW_FILE = os.getenv("FREEZE_WINDOW_FILE", "ci/freeze-windows.yaml")
FREEZE_ACTIVE_FILE: str = os.getenv("FREEZE_ACTIVE_FILE", "freeze_active")
LOG = logging.getLogger("freeze-windows")


class FreezeWindow(pydantic.BaseModel):
    start: datetime.datetime
    end: datetime.datetime
    reason: str


class FreezeWindowFile(pydantic.BaseModel):
    windows: list[FreezeWindow] | None = []


class LowercaseFormatter(logging.Formatter):
    def format(self, record):
        record.levelname = record.levelname.lower()
        if record.levelname == "info":
            record.levelname = "notice"
        return super().format(record)


def is_freeze_active(cfg: FreezeWindowFile) -> bool:
    now = datetime.datetime.now(datetime.timezone.utc)

    active: list[FreezeWindow] = []

    for w in cfg.windows or []:
        if w.start <= now <= w.end:
            active.append(w)

    if active:
        LOG.warning("FREEZE WINDOW IS ACTIVE - MERGES ARE BLOCKED")
        # Find the latest end time among all active freezes
        latest_end = max(w.end for w in active)
        LOG.info(
            f"Freeze windows will end on {latest_end.strftime('%Y-%m-%d %H:%M:%S UTC')}"
        )
        return True

    LOG.info("No freeze window is active - merges are allowed.")
    return False


def check(cfg: FreezeWindowFile):
    if is_freeze_active(cfg):
        sys.exit(1)


def recheck(cfg: FreezeWindowFile):
    if is_freeze_active(cfg):
        with open(FREEZE_ACTIVE_FILE, "w") as f:
            f.write("true")
    else:
        with open(FREEZE_ACTIVE_FILE, "w") as f:
            f.write("false")


def read_freeze_config() -> FreezeWindowFile:
    try:
        with open(FREEZE_WINDOW_FILE) as f:
            cfg = FreezeWindowFile.model_validate(yaml.safe_load(f))
            return cfg
    except FileNotFoundError:
        LOG.info(f"{FREEZE_WINDOW_FILE} not found - no freeze is active.")
        sys.exit(0)
    except (ValueError, yaml.YAMLError) as e:
        LOG.error(f"Failed to parse {FREEZE_WINDOW_FILE}: {e}")
        sys.exit(1)


def main():
    logging.basicConfig(level="INFO")
    for handler in logging.root.handlers:
        handler.setFormatter(LowercaseFormatter("::%(levelname)s::%(message)s"))

    p = argparse.ArgumentParser()
    p.add_argument("action")
    args = p.parse_args()

    cfg = read_freeze_config()

    if args.action == "check":
        check(cfg)
    elif args.action == "recheck":
        recheck(cfg)
    else:
        LOG.error(f"unknown action: {args.action}")


if __name__ == "__main__":
    main()
