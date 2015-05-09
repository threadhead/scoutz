require 'yaml'

# loads constants from a yaml file into a method with of the same name as the file
# i.e. /config/constants/users.yml => AppConstants.users

module AppConstants
  def self.load!
    if !constants_paths.nil? && !constants_paths.empty?
      constants_paths.each do |path|
        file_name = File.basename(path, '.yml')
        class_var_name = "@@#{file_name}".to_sym
        constants_yaml = YAML.load(File.open(path))
        self.class_variable_set(class_var_name, constants_yaml[file_name.to_sym])
        create_method(file_name) { self.class_variable_get(class_var_name) }
      end
    end
  end

  def self.constants_paths
    # Dir.glob('/Users/karl/scoutz/config/constants/*.yml')
    Object.const_defined?(:Rails) ? Dir.glob("#{Rails.root}/config/constants/*.yml") : nil
  end

  def self.create_method(name, &block)
    self.class.send(:define_method, name.to_sym, &block)
  end

end
AppConstants.load!
