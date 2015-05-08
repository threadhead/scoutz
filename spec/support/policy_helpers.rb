module PolicyHelpers
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # def permission_granted_role_level_up(role_level, policy_class)
    def permission_granted_role_level_up(options={})
      role_level = options[:role_level]
      policy_class = options[:policy_class]
      user_type = options[:user] || :user
      policy_resource = options[:policy_resource]

      describe "grants access #{user_type} role = #{role_level} and up" do
        user = FactoryGirl.build_stubbed(user_type)
        User.roles_at_and_above(role_level).each do |role, _val|
          it "permission +granted+ #{user_type}.role = #{role}" do
            user.role = role
            expect(policy_class).to permit(user, policy_resource)
          end
        end
      end
    end


    # def permission_denied_role_level_down(role_level, policy_class)
    def permission_denied_role_level_down(options={})
      role_level = options[:role_level]
      policy_class = options[:policy_class]
      user_type = options[:user] || :user
      policy_resource = options[:policy_resource]

      describe "denies access #{user_type} below role = #{role_level}" do
        user = FactoryGirl.build_stubbed(user_type)
        User.roles_at_and_below(role_level).each do |role, _val|
          it "permission -denied- #{user_type}.role = #{role}" do
            user.role = role
            expect(policy_class).not_to permit(user, policy_resource)
          end
        end
      end
    end

  end # ClassMethods



  RSpec.shared_examples 'adult admin access' do
    fail(NoMethodError, 'must define an options class method inside spec') unless self.respond_to?(:options)
    permission_granted_role_level_up(options.merge(user: :adult, role_level: :admin))
    permission_denied_role_level_down(options.merge(user: :adult, role_level: :leader))
    permission_denied_role_level_down(options.merge(user: :scout, role_level: :admin))
  end

  RSpec.shared_examples 'adult leader access' do
    fail(NoMethodError, 'must define an options class method inside spec') unless self.respond_to?(:options)
    permission_granted_role_level_up(options.merge(user: :adult, role_level: :leader))
    permission_denied_role_level_down(options.merge(user: :adult, role_level: :basic))
    permission_denied_role_level_down(options.merge(user: :scout, role_level: :admin))
  end

  RSpec.shared_examples 'user leader access' do
    fail(NoMethodError, 'must define an options class method inside spec') unless self.respond_to?(:options)
    permission_granted_role_level_up(options.merge(role_level: :leader))
    permission_denied_role_level_down(options.merge(role_level: :basic))
  end

  RSpec.shared_examples 'user basic access' do
    fail(NoMethodError, 'must define an options class method inside spec') unless self.respond_to?(:options)
    permission_granted_role_level_up(options.merge(role_level: :basic))
    permission_denied_role_level_down(options.merge(role_level: :inactive))
  end

  RSpec.shared_examples 'no access' do
    fail(NoMethodError, 'must define an options class method inside spec') unless self.respond_to?(:options)
    permission_denied_role_level_down(options.merge(role_level: :admin))
  end

  RSpec.shared_examples 'can access thier own' do
    klass = self.parent.parent.described_class
    it "users can #{self.parent.name.split('::').last.downcase} their own record" do
      expect(klass).to permit(@user, @record)
    end
  end

end
