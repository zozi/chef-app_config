class Chef
  module AppConfig
    module AppConfigMixin

      # Return all of an apps settings, included encrypted values. This will
      # deep merge the values from the app_name and app_name_secrets data bag
      # items.
      #
      # In each data bag, values from the node["app_config"]["default_environment"]
      # environment are also merged in. This can help stop duplication between
      # environments.
      #
      # options - The Hash options lets you override the default search:
      #   :app_name    - The application name (default: node["app_config"]["app_name"])
      #   :environment - The application environment (default: node["app_config"]["environment"])
      #   :data_bag    - The data bag to search (default: node["app_config"]["data_bag"])
      #
      # Returns a Mash.
      def app_config(options = {})
        app_name = fetch_option_or_raise(options, :app_name)
        environment = fetch_option_or_raise(options, :environment)
        data_bag = fetch_option_or_raise(options, :data_bag)

        Mash.new.tap do |config|
          [node["app_config"]["default_environment"], environment].compact.each do |env|
            Chef::Mixin::DeepMerge.deep_merge!(
              data_bag_item(data_bag, app_name)[env],
              config
            )
            Chef::Mixin::DeepMerge.deep_merge!(
              Chef::EncryptedDataBagItem.load(data_bag, "#{app_name}_secrets")[env],
              config
            )
          end
        end
      end

      private

      def fetch_option_or_raise(options, key)
        options[key] || node["app_config"][key] || raise("app_config: node['app_config']['#{key}'] not set")
      end

    end
  end
end
