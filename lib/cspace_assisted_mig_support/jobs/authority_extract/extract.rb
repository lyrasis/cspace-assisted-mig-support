# frozen_string_literal: true

module CspaceAssistedMigSupport
  module Jobs
    module AuthorityExtract
      module Extract
        module_function

        def job
          Kiba::Extend::Jobs::Job.new(
            files: {
              source: :authority_extract__orig,
              destination: :authority_extract__extract
            },
            transformer: xforms
          )
        end

        def xforms
          Kiba.job_segment do
            transform Cams::Transforms::AuthorityExtract::Extracter
          end
        end
      end
    end
  end
end
