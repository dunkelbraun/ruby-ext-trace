version_folder = "tmp/build/docker/#{version}"
empty_directory version_folder

inside "docker-ruby" do
  versions = in_root do
    YAML.load_file("docker_ruby_versions.yml")
  end
  run "git checkout #{versions[version]}", capture: true
end

in_root do
  glob = distro == "all" ? "*/Dockerfile" : "#{distro}/Dockerfile"
  dockerfiles = Dir.glob("docker-ruby/#{major_version}/#{glob}")
  dockerfiles.each do |source|
    info = source.split("/")
    dockerfile = "#{info[-2]}.Dockerfile"
    run "cp #{source} #{version_folder}/#{dockerfile}"
  end
end

inside "docker-ruby" do
  run "git checkout master", capture: true
end
