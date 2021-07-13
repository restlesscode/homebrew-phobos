class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.18.0.tar.gz"
  sha256 "1b14e338d3005a716d856352ae012b30f67632e232601ac0890619377ae481bd"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a023f81e3ae8a34609749db824fe75fcd1c65b672a3e522737a65ecc801f964d"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c7f2072fc885ca10a439367749c87a46e93955cad6148f59d0a2e71e0f9ef86"
    sha256 cellar: :any_skip_relocation, catalina:      "dcd34d9054ff13b8eae754378c5f8f64a24c8bfb93630aa98384aa5867d39dca"
  end

  depends_on xcode: ["10.2", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
    pkgshare.install "SettingPresets"
  end

  test do
    (testpath/"xcodegen.yml").write <<~EOS
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    EOS
    (testpath/"TestProject").mkpath
    system bin/"XcodeGen", "--spec", testpath/"xcodegen.yml"
    assert_predicate testpath/"GeneratedProject.xcodeproj", :exist?
    assert_predicate testpath/"GeneratedProject.xcodeproj/project.pbxproj", :exist?
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end
