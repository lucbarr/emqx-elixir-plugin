##--------------------------------------------------------------------
## Copyright (c) 2016-2017 EMQ Enterprise, Inc. (http://emqtt.io)
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##--------------------------------------------------------------------


defmodule EmqxCleanspeakPlugin.Body do
    
    require Record    

    Record.defrecord(:message, Record.extract(:message, from_lib: "emqx/include/emqx.hrl"))

    def hook_add(a, b, c) do
        :emqx_hooks.add(a, b, c)
    end
    
    def hook_del(a, b) do
        :emqx_hooks.del(a, b)
    end

    def load(env) do
        # uncomment the hooks that you want, and implement its callback
        
        #hook_add(:"client.authenticate",  &EmqxCleanspeakPlugin.Body.on_client_authenticate/2, [env])
        #hook_add(:"client.check_acl",     &EmqxCleanspeakPlugin.Body.on_client_check_acl/5,    [env])
        hook_add(:"message.publish",      &EmqxCleanspeakPlugin.Body.on_message_publish/2,     [env])
        #hook_add(:"message.deliver",      &EmqxCleanspeakPlugin.Body.on_message_deliver/3,     [env])
        #hook_add(:"message.acked",        &EmqxCleanspeakPlugin.Body.on_message_acked/3,       [env])
        #hook_add(:"client.connected",     &EmqxCleanspeakPlugin.Body.on_client_connected/4,    [env])
        #hook_add(:"client.subscribe",     &EmqxCleanspeakPlugin.Body.on_client_subscribe/3,    [env])
        #hook_add(:"client.unsubscribe",   &EmqxCleanspeakPlugin.Body.on_client_unsubscribe/3,  [env])
        #hook_add(:"client.disconnected",  &EmqxCleanspeakPlugin.Body.on_client_disconnected/3, [env])
        #hook_add(:"session.subscribed",   &EmqxCleanspeakPlugin.Body.on_session_subscribed/4,  [env])
        #hook_add(:"session.unsubscribed", &EmqxCleanspeakPlugin.Body.on_session_unsubscribed/4,[env])
    end

    def unload do
        # uncomment the hooks that you want

        #hook_del(:"client.authenticate",  &EmqxCleanspeakPlugin.Body.on_client_authenticate/2 )
        #hook_del(:"client.check_acl",     &EmqxCleanspeakPlugin.Body.on_client_check_acl/5    )
        hook_del(:"message.publish",      &EmqxCleanspeakPlugin.Body.on_message_publish/2     )
        #hook_del(:"message.deliver",      &EmqxCleanspeakPlugin.Body.on_message_deliver/3     )
        #hook_del(:"message.acked",        &EmqxCleanspeakPlugin.Body.on_message_acked/3       )
        #hook_del(:"client.connected",     &EmqxCleanspeakPlugin.Body.on_client_connected/4    )
        #hook_del(:"client.subscribe",     &EmqxCleanspeakPlugin.Body.on_client_subscribe/3    )
        #hook_del(:"client.unsubscribe",   &EmqxCleanspeakPlugin.Body.on_client_unsubscribe/3  )
        #hook_del(:"client.disconnected",  &EmqxCleanspeakPlugin.Body.on_client_disconnected/3 )
        #hook_del(:"session.subscribed",   &EmqxCleanspeakPlugin.Body.on_session_subscribed/4  )
        #hook_del(:"session.unsubscribed", &EmqxCleanspeakPlugin.Body.on_session_unsubscribed/4)
    end

    def on_client_authenticate(credentials, _env) do
        IO.inspect(["elixir on_client_authenticate", credentials])

        {:stop, Map.put(credentials, :auth_result, :success)}
    end

    def on_client_check_acl(credentials, pubsub, topic, defult_result, _env) do
        IO.inspect(["elixir on_client_check_acl", credentials, pubsub, topic, defult_result])

        {:stop, :allow}
    end
    
    def on_message_publish(msg = message(topic: <<"$SYS/", _ :: binary>>), _env) do
        # ingore SYS messages

        {:ok, msg}
    end

    def on_message_publish(msg, _env) do

        # add your elixir code here
        msg = message(msg, payload: <<60, 60, 60>>)
        IO.inspect(["elixir on_message_publish", msg])
        
        {:ok, msg}
    end
    
    def on_message_deliver(credentials, message, _env) do
        IO.inspect(["elixir on_message_deliver", credentials, message])

        # add your elixir code here

        :ok
    end
    
    def on_message_acked(credentials, message, _env) do
        IO.inspect(["elixir on_message_acked", credentials, message])
        
        # add your elixir code here
        
        :ok
    end
    
    def on_client_connected(credentials, connack, attrs, _env) do
        IO.inspect(["elixir on_client_connected", credentials, connack, attrs])

        # add your elixir code here

        :ok
    end
    
    def on_client_disconnected(credentials, reasoncode, _env) do
        IO.inspect(["elixir on_client_disconnected", credentials, reasoncode])
        
        # add your elixir code here
        
        :ok
    end
    
    def on_client_subscribe(credentials, topictable, _env) do
        IO.inspect(["elixir on_client_subscribe", credentials, topictable])
        
        # add your elixir code here
        
        {:ok, topictable}
    end
    
    def on_client_unsubscribe(credentials, topictable, _env) do
        IO.inspect(["elixir on_client_unsubscribe", credentials, topictable])
        
        # add your elixir code here
        
        {:ok, topictable}
    end
    
    def on_session_subscribed(credentials, topic, subopts, _env) do
        IO.inspect(["elixir on_session_subscribed", credentials, topic, subopts])
        
        # add your elixir code here
        
        {:ok, subopts}
    end
    
    def on_session_unsubscribed(credentials, topic, opts, _env) do
        IO.inspect(["elixir on_session_unsubscribed", credentials, topic, opts])
        
        # add your elixir code here
        
        {:ok, opts}
    end
end

