class Pomodorough < Formula
  include Language::Python::Virtualenv

  desc "Local-first Pomodoro timer with desktop, CLI, and TUI clients"
  homepage "https://github.com/egigoka/pomodorough-linux"
  url "https://github.com/egigoka/pomodorough-linux/releases/download/v0.1.2/pomodorough_linux-0.1.2.tar.gz"
  sha256 "f7bacf7f6f7005ee6910595230ce2fd9d52005f54fc88f944ca96e3c8da0a74c"
  license "GPL-3.0-or-later"

  depends_on "pyside"
  depends_on "python@3.14"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/5d/40/e1e72872c6354b306daef1703549e8e83b4d43cfea356311bf722a043752/setuptools-83.0.0-py3-none-any.whl"
    sha256 "29b23c360f22f414dc7336bb39178cc7bcbf6021ed2733cde173f09dba19abb3"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resource("setuptools"), build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    database = testpath/"state.sqlite3"
    output = shell_output("#{bin}/pomodorough-cli --data #{database} status --json")
    assert_match '"status": "idle"', output
    assert_match "Run Pomodorough", shell_output("#{bin}/pomodorough-tui --help")
    system libexec/"bin/python", "-c", "import PySide6"
  end
end
