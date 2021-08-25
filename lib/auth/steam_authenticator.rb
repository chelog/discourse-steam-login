# frozen_string_literal: true

class Auth::SteamAuthenticator < ::Auth::ManagedAuthenticator
  def name
    'steam'
  end

  def enabled?
    SiteSetting.enable_steam_logins
  end

  def can_revoke?
    SiteSetting.steam_allow_revoke
  end

  def description_for_auth_hash(auth_token)
    return if auth_token&.info.nil?
    info = auth_token.info
    extra = auth_token.extra
    extra["raw_info"]["steamid"] || info["nickname"]
  end

  def register_middleware(omniauth)
    omniauth.provider :steam, setup: lambda { |env|
      strategy = env["omniauth.strategy"]
      strategy.options[:api_key] = SiteSetting.steam_web_api_key
    }
  end
end
