require 'faker'

module Agents
  class FakerAgent < Agent
    include FormConfigurable

    can_dry_run!
    no_bulk_receive!
    default_schedule "never"

    description do
      <<-MD
      The huginn catalog agent checks if new campaign is available.

      `debug` is used to verbose mode.

      `country` is for generating data from specifiq country, like fr.

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
        'country' => 'fr',
        'debug' => 'false',
        'is_male' => 'true',
        'first_name' => 'true',
        'last_name' => 'true',
        'full_address' => 'false',
        'blood_group' => 'false',
        'job_title' => 'false',
        'phone_number' => 'false',
        'birth_date' => 'false',
        'btc_address' => 'false',
        'eth_address' => 'false',
        'twitter_account' => 'false',
      }
    end

    form_configurable :debug, type: :boolean
    form_configurable :country, type: :array, values: ['fr', 'ro', 'en', 'es', 'it']
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

    def working?
      event_created_within?(options['expected_receive_period_in_days']) && !recent_error_logs?
    end

    def check
      generate
    end

    private

    def generate
      case interpolated['country']
      when "us"
        Faker::Config.locale = :ro
      when "fr"
        Faker::Config.locale = :fr
      when "en"
        Faker::Config.locale = :en
      when "es"
        Faker::Config.locale = :es
      when "it"
        Faker::Config.locale = :it
      end


      if interpolated['debug'] == 'true'
        log "country is #{interpolated['country']}"
      end      
      
      if interpolated['is_male'] == 'true'
        then
          if interpolated['debug'] == 'true'
            log "You're a male"
          end      
          first_name = Faker::Name.male_first_name
        else
          if interpolated['debug'] == 'true'
            log "You're a female"
          end      
          first_name = Faker::Name.female_first_name
      end
      
      json = Hash.new
      json["first_name"] = "#{first_name}"
      if interpolated['first_name'] == 'true'
        if interpolated['debug'] == 'true'
          log "#{json}"
        end 
      end 
      if interpolated['last_name'] == 'true'
        json["last_name"] = "#{Faker::Name.last_name}"
        if interpolated['debug'] == 'true'
          log "#{json}"
        end
      end 
      if interpolated['full_address'] == 'true'
        json["full_address"] = "#{Faker::Address.full_address}"
        if interpolated['debug'] == 'true'
          log "#{json}"
        end      
      end 
      if interpolated['blood_group'] == 'true'
        json["blood_group"] = "#{Faker::Blood.group}"
        if interpolated['debug'] == 'true'
          log "#{json}"
        end      
      end 
      if interpolated['job_title'] == 'true'
        json["job_title"] = "#{Faker::Job.title}"
        if interpolated['debug'] == 'true'
          log "#{json}"
        end      
      end 
      if interpolated['phone_number'] == 'true'
        json["phone_number"] = "#{Faker::PhoneNumber.phone_number_with_country_code}"
        if interpolated['debug'] == 'true'
          log "#{json}"
        end      
      end 
      if interpolated['birth_date'] == 'true'
        json["birth_date"] = "#{Faker::Date.birthday(min_age: 18, max_age: 45)}"
        if interpolated['debug'] == 'true'
          log "#{json}"
        end      
      end 
      if interpolated['btc_address'] == 'true'
        json["btc_address"] = "#{Faker::Blockchain::Bitcoin.address}"
        if interpolated['debug'] == 'true'
          log "#{json}"
        end      
      end 
      if interpolated['eth_address'] == 'true'
        json["eth_address"] = "#{Faker::Blockchain::Ethereum.address}"
        if interpolated['debug'] == 'true'
          log "#{json}"
        end      
      end 
      if interpolated['twitter_account'] == 'true'
        json["twitter_account"] = "#{Faker::Twitter.user}"
        if interpolated['debug'] == 'true'
          log "#{json}"
        end      
      end 
      create_event payload: json
    end
  end
end
