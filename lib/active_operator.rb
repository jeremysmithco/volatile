module ActiveOperator
  def self.table_name_prefix
    "active_operator_"
  end

  module Model
    extend ActiveSupport::Concern

    class_methods do
      def has_operation(name, version: 1)
        generated_association_methods.class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{name}
            @active_operation_operables ||= {}
            @active_operation_operables[:#{name}] ||= ActiveOperator::Operable.new(self, "#{name}", #{version})
          end
        CODE

        has_one :"#{name}_operation", -> { where(name: name, version: version) }, class_name: "ActiveOperator::Operation", as: :record, inverse_of: :record, dependent: :destroy
      end
    end
  end

  class Operable
    # delegate_missing_to :operation #, allow_nil: true
    delegate :received?, :processed?, :failed?, to: :operation

    attr_reader :record, :name, :version

    def initialize(record, name, version)
      @record, @name, @version = record, name, version
      @operation = find_or_build_operation
    end

    def operate
      return false if !record.persisted?
      operation.save! if !operation.persisted?

      operation.operate!
    end

    def operate_later
      return false if !record.persisted?
      operation.save! if !operation.persisted?

      ActiveOperator::OperateJob.perform_later(operation)
    end

    private

    attr_reader :operation

    def find_or_build_operation
      record.public_send("#{name}_operation") || ActiveOperator::Operation.new(record: record, name: name, version: version)
    end
  end

  class Operator
    def initialize(operation)
      @operation = operation
    end

    def request
      raise "Must implement"
    end

    def process
      raise "Must implement"
    end

    private

    attr_reader :operation
    delegate :record, :response, to: :operation
  end
end
