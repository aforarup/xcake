module Xcake
  PUBLIC_HEADER_ATTRIBUTE = { 'ATTRIBUTES' => ['Public'] }.freeze
  PRIVATE_HEADER_ATTRIBUTE = { 'ATTRIBUTES' => ['Private'] }.freeze

  # This class is used to represent a copy headers build phase
  #
  class HeadersBuildPhase < BuildPhase
    attr_accessor :public
    attr_accessor :private
    attr_accessor :project

    def initialize
      @public = []
      @private = []
      @project = []

      yield(self) if block_given?
    end

    def public_header_files(reg_exp)
      paths_without_directories = Dir.glob(reg_exp).reject do |f|
        file_ext = File.extname(f)
        allowed_extensions = %w(.h .hpp)
        File.directory?(f) && !allowed_extensions.include?(file_ext)
      end
      paths = paths_without_directories.map do |f|
        Pathname.new(f).cleanpath.to_s
      end
      @public |= paths
    end

    def build_phase_type
      Xcodeproj::Project::Object::PBXHeadersBuildPhase
    end

    def configure_native_build_phase(native_build_phase, context)
      @public.each do |file|
        file_reference = context.file_reference_for_path(file)
        build_file = native_build_phase.add_file_reference(file_reference)
        build_file.settings = PUBLIC_HEADER_ATTRIBUTE
      end

      @private.each do |file|
        file_reference = context.file_reference_for_path(file)
        build_file = native_build_phase.add_file_reference(file_reference)
        build_file.settings = PRIVATE_HEADER_ATTRIBUTE
      end

      @project.each do |file|
        file_reference = context.file_reference_for_path(file)
        native_build_phase.add_file_reference(file_reference)
      end
    end

    def to_s
      'BuildPhase<Copy Headers>'
    end
  end
end
