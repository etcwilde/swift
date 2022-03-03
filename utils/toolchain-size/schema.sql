PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS platform (
  pid  INTEGER PRIMARY KEY,   -- platform id
  name TEXT                   -- platform name (windows, linux, macos)
);

CREATE TABLE IF NOT EXISTS toolchain (
  tid  INTEGER PRIMARY KEY,   -- toolchain id
  name TEXT                   -- toolchain name
);

CREATE TABLE IF NOT EXISTS sdk (
  sid  INTEGER PRIMARY KEY,   -- sdk id
  name TEXT                   -- sdk name
);

CREATE TABLE IF NOT EXISTS files (
  fid  INTEGER PRIMARY KEY,   -- file id
  path text                   -- file path
);

CREATE TABLE IF NOT EXISTS build_info (
  bid  INTEGER PRIMARY KEY,   -- build id
  date TEXT,                  -- build date
  pid  INTEGER,               -- platform id
  blob TEXT,                  -- extra metadata
  FOREIGN KEY(pid) REFERENCES platform(pid)
);

CREATE TABLE IF NOT EXISTS size (
  bid   INTEGER,              -- build id
  fid   INTEGER,              -- file id
  bytes INTEGER,              -- number of bytes in the file for this build
  PRIMARY KEY(bid, fid),
  FOREIGN KEY(bid) REFERENCES build_info(bid),
  FOREIGN KEY(fid) REFERENCES files(fid)
);

CREATE TABLE IF NOT EXISTS toolchain_files (
  tid  INTEGER,               -- toolchain id
  fid  INTEGER,               -- file id
  bid  INTEGER,               -- build id
  PRIMARY KEY(tid, fid, bid),
  FOREIGN KEY(tid) REFERENCES toolchain(tid),
  FOREIGN KEY(fid) REFERENCES files(fid),
  FOREIGN KEY(bid) REFERENCES build_info(bid)
);

CREATE TABLE IF NOT EXISTS sdk_files (
  sid  INTEGER,               -- SDK id
  fid  INTEGER,               -- file id
  bid  INTEGER,               -- build id
  PRIMARY KEY(sid, fid, bid),
  FOREIGN KEY(sid) REFERENCES sdk(sid),
  FOREIGN KEY(fid) REFERENCES files(fid),
  FOREIGN KEY(bid) REFERENCES build_info(bid)
);
