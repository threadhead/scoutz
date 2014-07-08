module PolicyHelpers
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # def permission_granted_role_level_and_up(role_level, policy_class)
    def permission_granted_role_level_and_up(options={})
      role_level = options[:role_level]
      policy_class = options[:policy_class]
      user_type = options[:user] || :user
      policy_resource = options[:policy_resource]

      describe "grants access #{user_type} role = #{role_level} and up" do
        roles_at_and_above(role_level).each do |role, val|
          it "permission +granted+ #{user_type}.role = #{role}" do
            expect(policy_class).to permit(FactoryGirl.build_stubbed(user_type, role: role), policy_resource)
          end
        end
      end
    end


    # def permission_denied_below_role_level(role_level, policy_class)
    def permission_denied_below_role_level(options={})
      role_level = options[:role_level]
      policy_class = options[:policy_class]
      user_type = options[:user] || :user
      policy_resource = options[:policy_resource]

      describe "denies access #{user_type} below role = #{role_level}" do
        roles_at_and_below(role_level).each do |role, val|
          it "permission -denied- #{user_type}.role = #{role}" do
            expect(policy_class).not_to permit(FactoryGirl.build_stubbed(user_type, role: role), policy_resource)
          end
        end
      end
    end


    def roles_at_and_above(role_q)
      User.roles.select { |r| User.roles[r] >= User.roles[role_q.to_s] }
    end

    def roles_at_and_below(role_q)
      User.roles.select { |r| User.roles[r] <= User.roles[role_q.to_s] }
    end
  end



end
