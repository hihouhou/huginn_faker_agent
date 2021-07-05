require 'faker'

module Agents
  class FakerAgent < Agent
    include FormConfigurable
#
#    gem_dependency_check { defined?(faker) }

    can_dry_run!
    no_bulk_receive!
    default_schedule "never"

    description do
      <<-MD
      The huginn catalog agent checks if new campaign is available.
#
#      #{'## Include the `faker` gem in your `Gemfile` to use faker Agents.' if dependencies_missing?}

      `debug` is used to verbose mode.

      `country` is for generating data from specifiq country, like us.

      `is_male` is for generating data from specifiq gender.

      `first_name` is for generating first name field.

      `last_name` is for generating last name field.

      `full_address` is for generating a full address.

      `blood_group` is for generating a blood group.

      `job_title` is for generating a job title.

      `phone_number` is for generating a phone number.

      `birth_date` is for generating a birth date.

      `btc_address` is for generating a btc address.

      `eth_address` is for generating a eth address.

      `twitter_account` is for generating a twitter account.

      `expected_receive_period_in_days` is used to determine if the Agent is working. Set it to the maximum number of days
      that you anticipate passing without this Agent receiving an incoming Event.
      MD
    end

    event_description <<-MD
      Events look like this:
        {
        }
    MD

    def default_options
      {
        'debug' => 'False',
        'country' => 'us',
        'is_male' => 'True',
      }
    end

    form_configurable :debug, type: :boolean
    form_configurable :country, type: :boolean
    form_configurable :is_male, type: :boolean
    form_configurable :first_name, type: :boolean
    form_configurable :last_name, type: :boolean
    form_configurable :full_address, type: :boolean
    form_configurable :blood_group, type: :boolean
    form_configurable :job_title, type: :boolean
    form_configurable :phone_number, type: :boolean
    form_configurable :birth_date, type: :boolean
    form_configurable :btc_address, type: :boolean
    form_configurable :eth_address, type: :boolean
    form_configurable :twitter_account, type: :boolean
    def validate_options

      if options.has_key?('debug') && boolify(options['debug']).nil?
        errors.add(:base, "if provided, debug must be true or false")
      end
    end

#    def working?
#    end

    def doit
      generate
    end

    private

    def generate
      
      Faker::Config.locale = :interpolated['country']

      if interpolated['debug'] == 'true'
        logs "contry is #{interpolated['country']}"
      end      
      
      if (is_male)
        then
          if interpolated['debug'] == 'true'
            logs "You're a male"
          end      
          first_name = Faker::Name.male_first_name
        else
          if interpolated['debug'] == 'true'
            logs "You're a female"
          end      
          first_name = Faker::Name.female_first_name
      end
      
      json = Hash.new
      json["first_name"] = "#{first_name}"
      if interpolated['first_name'] == 'true'
        if interpolated['debug'] == 'true'
          logs "#{json}"
        end 
      end 
      if interpolated['last_name'] == 'true'
        json["last_name"] = "#{Faker::Name.last_name}"
        if interpolated['debug'] == 'true'
          logs "#{json}"
        end
      end 
      if interpolated['full_address'] == 'true'
        json["full_address"] = "#{Faker::Address.full_address}"
        if interpolated['debug'] == 'true'
          logs "#{json}"
        end      
      end 
      if interpolated['blood_group'] == 'true'
        json["blood_group"] = "#{Faker::Blood.group}"
        if interpolated['debug'] == 'true'
          logs "#{json}"
        end      
      end 
      if interpolated['job_title'] == 'true'
        json["job_title"] = "#{Faker::Job.title}"
        if interpolated['debug'] == 'true'
          logs "#{json}"
        end      
      end 
      if interpolated['phone_number'] == 'true'
        json["phone_number"] = "#{Faker::PhoneNumber.phone_number_with_country_code}"
        if interpolated['debug'] == 'true'
      logs "#{json}"
        end      
      end 
      if interpolated['birth_date'] == 'true'
        json["birth_date"] = "#{Faker::Date.birthday(min_age: 18, max_age: 45)}"
        if interpolated['debug'] == 'true'
          logs "#{json}"
        end      
      end 
      if interpolated['btc_address'] == 'true'
        json["btc_address"] = "#{Faker::Blockchain::Bitcoin.address}"
        if interpolated['debug'] == 'true'
          logs "#{json}"
        end      
      end 
      if interpolated['eth_address'] == 'true'
        json["eth_address"] = "#{Faker::Blockchain::Ethereum.address}"
        if interpolated['debug'] == 'true'
          logs "#{json}"
        end      
      end 
      if interpolated['twitter_account'] == 'true'
        json["twitter_account"] = "#{Faker::Twitter.user}"
        if interpolated['debug'] == 'true'
          logs "#{json}"
        end      
      end 
      create_event payload: json
    end
  end
end
