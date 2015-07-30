%
% API for elasitc transcoder
%

-module(erlcloud_et).
-export([
    new/2, new/3,
    configure/2, configure/3,
    create_job/1, create_job/2,
    presets_list/0, presets_list/1
]).

-include("erlcloud.hrl").
-include("erlcloud_aws.hrl").
-define(API_VERSION, "2012-09-25").


-spec(new/2 :: (string(), string()) -> aws_config()).
new(AccessKeyID, SecretAccessKey) ->
    #aws_config{access_key_id=AccessKeyID,
                secret_access_key=SecretAccessKey}.

-spec(new/3 :: (string(), string(), string()) -> aws_config()).
new(AccessKeyID, SecretAccessKey, Host) ->
    #aws_config{access_key_id=AccessKeyID,
                secret_access_key=SecretAccessKey,
                et_host=Host}.

-spec(configure/2 :: (string(), string()) -> ok).
configure(AccessKeyID, SecretAccessKey) ->
    put(aws_config, new(AccessKeyID, SecretAccessKey)),
    ok.

-spec(configure/3 :: (string(), string(), string()) -> ok).
configure(AccessKeyID, SecretAccessKey, Host) ->
    put(aws_config, new(AccessKeyID, SecretAccessKey, Host)),
    ok.

create_job(Struct) ->
    create_job(Struct, erlcloud_aws:default_config()).
create_job(Struct, Config) ->
    JSON = jsx:encode(Struct),
    erlcloud_aws:aws_request_json4(post, "https", Config#aws_config.et_host, 443,
                                  "/2012-09-25/jobs", {[],JSON}, "elastictranscoder", Config).

presets_list() -> presets_list(erlcloud_aws:default_config()).
presets_list(Config) -> 
    erlcloud_aws:aws_request_json4(get, "https", Config#aws_config.et_host, 443,
                                  "/2012-09-25/presets", [], "elastictranscoder", Config).

