# frozen_string_literal: true

module CspaceAssistedMigSupport
  module Transforms
    module AuthorityExtract
      class Extracter
        VALUE_TARGET = :value
        SOURCE_TARGET = :source

        # @param headers [Array<Symbol>] from which to extract values
        # @param value_target [Symbol]
        # @param source_target [Symbol]
        def initialize(headers: Cams.authority_extract_headers,
                       value_target: VALUE_TARGET,
                       source_target: SOURCE_TARGET)
          @headers = headers
          @value_target = value_target
          @source_target = source_target
          @rows = []
        end

        def process(row)
          headers.map { |hdr| header_and_value(hdr, row) }
            .compact
            .each { |rowhash| yield rowhash }

          nil
        end

        private

        attr_reader :headers, :value_target, :source_target

        def header_and_value(hdr, row)
          val = row[hdr]
          return nil if val.blank?

          {value_target => val, source_target => hdr}
        end
      end
    end
  end
end
