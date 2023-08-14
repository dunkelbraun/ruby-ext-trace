version_folder = "tmp/build/docker/#{version}"
empty_directory version_folder

docker_patch_ruby = <<-PATCH
  patch -p1 -i /usr/ruby-patch/ruby.patch; \\
  rm /usr/ruby-patch/ruby.patch; \\
  autoconf; \\
PATCH

docker_patch_copy = <<~COPY_FILE

  COPY ruby.patch /usr/ruby-patch/ruby.patch
COPY_FILE

inside version_folder do
  dockerfiles = Dir.glob("*.Dockerfile")
  dockerfiles.each do |dockerfile|
    basename = File.basename(dockerfile, ".Dockerfile")
    next unless distro == "all" || basename == distro

    gsub_file(dockerfile, /autoconf; \\\n/, docker_patch_ruby)
    insert_into_file dockerfile, docker_patch_copy, after: /FROM .+$\n/
  end
end
