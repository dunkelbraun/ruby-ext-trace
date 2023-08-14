require "yaml"
require "dotenv"

class RubyExtTrace < Thor
  include Thor::Actions
  source_paths << File.join(__dir__, "recipes")

  def self.exit_on_failure?
    true
  end

  no_commands do
    def version
      options[:ruby_version]
    end

    def major_version
      version.split(".")[0..1].join(".")
    end

    def underscored_version
      options[:ruby_version].gsub(".", "_")
    end

    def distro
      options[:distro]
    end
  end

  class_option :ruby_version, aliases: "-v", desc: "Ruby version to build", required: true
  class_option :distro, aliases: "-d", desc: "Distribution to build", required: true,
                        enum: %w[all alpine3.16 alpine3.17 bullseye buster slim-bullseye slim-buster]

  desc "build", "Build custom ruby docker images"
  def build
    Dotenv.load(".env")
    apply "copy_ruby_patch.rb"
    apply "copy_dockerfiles.rb"
    apply "modify_dockerfiles.rb"
    apply "build_docker_images.rb"
  end

  desc "push", "Push custom Ruby docker images"
  def push
    Dotenv.load(".env")
    apply "push_docker_images.rb"
  end
end
