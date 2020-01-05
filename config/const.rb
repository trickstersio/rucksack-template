require "pathname"
require "fileutils"

ROOT_PATH = Pathname.new(File.expand_path("../", __dir__))
LIB_PATH = Pathname.new(File.expand_path("./lib", ROOT_PATH))
APP_PATH = Pathname.new(File.expand_path("./app", ROOT_PATH))
CONFIG_PATH = Pathname.new(File.expand_path("./config", ROOT_PATH))
DB_PATH = Pathname.new(File.expand_path("./db", ROOT_PATH))
TMP_PATH = Pathname.new(File.expand_path("./tmp", ROOT_PATH))
