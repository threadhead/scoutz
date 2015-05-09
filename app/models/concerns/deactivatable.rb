module Deactivatable
  extend ActiveSupport::Concern

  included do
    # Define the calling class as being deactivatable.
    # Options
    #   :dependencies - A list of symbols specifying any associations that are also deactivatable.  (The dependent association must separately be defined with acts_as_deactivatable).
    #   :auto_configure_dependencies - true or false (default).  If set to true, any association defined as dependent: :destroy or dependent: :delete_all will be added to the list of dependencies to deactivate.  NOTE: This call must occur after your dependency definitions to work properly.
    #

    # attr_protected :deactivated_at
    # attr_accessible :active_check_box

    # default_scope where(deactivated_at: nil)
    scope :active, -> { where(deactivated_at: nil) }
    scope :deactivated, -> { where.not(deactivated_at: nil) }

    # @deactivatable_options = options = {}
    @deactivatable_options = {}
    setup_autoconfigured_dependencies if @deactivatable_options[:auto_configure_dependencies]

    before_save :update_changed_by
  end





  class_methods do
    def deactivatable_options
      @deactivatable_options || {}
    end

    # Yields to a block, executing that block after removing the deactivated_at scope.
    #
    def with_deactivated_objects_scope
      remove_deactivated_objects_scope do
        with_scope(find: where("\"#{self.table_name}\".\"deactivated_at\" IS NOT NULL")) do
          yield
        end
      end
    end

    # Remove any scope related to deactivated_at and yield.
    #
    def remove_deactivated_objects_scope
      # with_exclusive_scope(scoped_methods_without_deactivated_at_scope) do
      with_exclusive_scope do
        yield
      end
    end

    def after_deactivation_filters
      @after_deactivation_filters || []
    end

    def after_deactivation(kind)
      @after_deactivation_filters ||= []
      @after_deactivation_filters << kind.to_s
    end

    def deactivatable_user_resource(resource)
      @deactivatable_user_resource = resource
    end

    def deactivatable_resource
      @deactivatable_user_resource ||= (User if defined?(User))
    end



    private

      # Scan the reflection associations defined on the current class,
      # if the :dependent option is set to :destroy or :delete_all then add that reflection to the list of dependencies to be deactivated.
      #
      def setup_autoconfigured_dependencies
        self.reflections.each_key { |reflection_name| setup_auto_configured_dependency(reflection_name) }
      end

      def setup_auto_configured_dependency(reflection_name)
        @deactivatable_options[:dependencies] ||= []
        reflection = self.reflections[reflection_name]

        if [:destroy, :delete_all].include?(reflection.options[:dependent])
          @deactivatable_options[:dependencies] << reflection_name
        end
      end
  end




  ## InstanceMethods

  # Deactivate this object, and any associated objects as specified at definition time.
  #
  def deactivate!
    with_transaction do
      self.deactivated_at = Time.zone.now
      deactivate_dependencies
      self.save(validate: false)
    end
    after_deactivation_callback
  end

  # Activate this object, and any associated objects as specified at definition time.
  #
  def activate!
    with_transaction do
      self.deactivated_at = nil
      activate_dependencies
      self.save!
    end
  end

  def deactivated?
    deactivated_at?
  end

  def active?
    !deactivated_at?
  end

  def active_changed_by
    if self.class.deactivatable_resource && has_active_changed_by_id
      self.class.deactivatable_resource.find_by_id(active_changed_by_id)
    else
      nil
    end
  end


  # activate_check_box virtual attribute to allow activating/deactivating using form check box
  #
  def active_check_box
    active?
  end

  def active_check_box=(value)
    if deactivated? && value == '1'
      self.deactivated_at = nil
      with_transaction { activate_dependencies }
    elsif active? && value == '0'
      self.deactivated_at = Time.now
      with_transaction { deactivate_dependencies }
    end
  end


  private

    # Iterate the list of associated objects that need to be deactivated, and deactivate each of them.
    #
    def deactivate_dependencies
      traverse_dependencies(:deactivate!)
    end

    # Iterate the list of associated objects that need to be activated, and activate each of them.
    #
    def activate_dependencies
      traverse_dependencies(:activate!)
    end

    # Traverse the list of dependencies, executing *method* on each of them.
    #
    def traverse_dependencies(method)
      if (dependencies = self.class.deactivatable_options[:dependencies])
        dependencies.each { |dependency_name| execute_on_dependency(dependency_name, method) }
      end
    end

    # Find the dependency indicated by *dependency_name* and execute *method* on it.
    # Execution must be wrapped in the dependency's with_deactivated_objects_scope for activate! to work.
    #
    def execute_on_dependency(dependency_name, method)
      self.class.reflections[dependency_name].klass.send(:with_exclusive_scope) do
        if dependency == self.__send__(dependency_name)
          dependency.respond_to?(:map) ? dependency.map(&method) : dependency.__send__(method)
        end
      end
    end

    def with_transaction
      self.class.transaction do
        yield
      end
    end

    def has_active_changed_by_id
      self.class.column_names.include?('active_changed_by_id')
    end


    def after_deactivation_callback
      self.class.after_deactivation_filters.each { |filter| self.send(filter) }
    end

    def update_changed_by
      if self.class.deactivatable_resource && has_active_changed_by_id && self.class.deactivatable_resource.respond_to?(:current) && deactivated_at_changed?
        self.active_changed_by_id = self.class.deactivatable_resource.current.try(:id)
      end
    end

end
