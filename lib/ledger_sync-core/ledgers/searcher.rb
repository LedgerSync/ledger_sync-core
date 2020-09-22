# frozen_string_literal: true

module LedgerSync
  module Ledgers
    class Searcher
      include SimplySerializable::Mixin
      include Mixins::InferResourceClassMixin
      include Mixins::InferSerializerMixin
      include Mixins::SerializationMixin

      attr_reader :client,
                  :query,
                  :pagination,
                  :request

      simply_serialize only: %i[
        client
        query
        pagination
        resources
      ]

      def initialize(client:, query:, pagination: {})
        @client = client
        @query = query
        @pagination = pagination
      end

      def deserializer_class
        @deserializer_class ||= self.class.inferred_deserializer_class
      end

      def next_searcher
        raise NotImplementedError
      end

      def previous_searcher
        raise NotImplementedError
      end

      def resources
        raise NotImplementedError
      end

      def search
        @search ||= success
      end

      private

      def paginate(**keywords)
        self.class.new(
          client: client,
          query: query,
          pagination: keywords
        )
      end

      def success
        SearchResult.Success(
          searcher: self
        )
      end

      def failure(searcher: nil, **keywords)
        SearchResult.Failure(
          searcher: searcher || self,
          **keywords
        )
      end
    end
  end
end
