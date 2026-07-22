class Pomodorough < Formula
  include Language::Python::Virtualenv

  desc "Local-first Pomodoro timer with desktop, CLI, and TUI clients"
  homepage "https://github.com/egigoka/pomodorough-linux"
  url "https://github.com/Pomodoro-Everywhere/pomodorough-linux/releases/download/v0.1.3/pomodorough_linux-0.1.3.tar.gz"
  sha256 "c2f0502eebb95bf85f9c68718fe133e149767e77bcd94b414a1ccde5573e6bc0"
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
