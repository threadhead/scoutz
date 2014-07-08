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
        User.roles_at_and_above(role_level).each do |role, val|
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
        User.roles_at_and_below(role_level).each do |role, val|
          it "permission -denied- #{user_type}.role = #{role}" do
            user.role = role
            expect(policy_class).not_to permit(user, policy_resource)
          end
        end
      end
    end

  end
end
