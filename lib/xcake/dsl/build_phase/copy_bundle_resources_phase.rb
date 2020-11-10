module Xcake
  # This class is used to represent a copy bundle resources build phase
  #
  class CopyBundleResourcesBuildPhase < BuildPhase
    # The name of files/folders to copy
    attr_accessor :files
    def initialize
      @files = []
      yield(self) if block_given?
    end

    def build_phase_type
      Xcodeproj::Project::Object::PBXResourcesBuildPhase
    end

    def configure_native_build_phase(native_build_phase, context)
      @files.each do |file|
        file_reference = context.file_reference_for_path(file)
        native_build_phase.add_file_reference(file_reference)
      end
    end

    def to_s
      'BuildPhase<Copy Bundle Resources>'
    end
  end
end
