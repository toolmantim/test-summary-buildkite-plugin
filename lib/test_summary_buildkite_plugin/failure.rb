# frozen_string_literal: true

module TestSummaryBuildkitePlugin
  module Failure
    class Base
      def sort_key
        raise 'abstract method'
      end

      def summary
        raise 'abstract method'
      end

      def verbose_markdown
        raise 'abstract method'
      end
    end

    class Unstructured < Base
      attr_reader :summary

      def initialize(summary)
        @summary = summary
      end

      alias sort_key summary

      def details; end
    end

    class Structured < Base
      attr_reader :file, :line, :column, :name, :details

      def initialize(file:, name:, line: nil, column: nil, details: nil)
        @file = file
        @line = line
        @column = column
        @name = name
        @details = details
      end

      def sort_key
        [file, line, column, name, details]
      end

      def summary
        "#{location}: #{name}"
      end

      private

      def location
        if line && column
          "#{file}:#{line}:#{column}"
        elsif line
          "#{file}:#{line}"
        else
          file
        end
      end
    end
  end
end