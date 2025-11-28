#!/bin/sh
#
# chatgpt wrote this
ZONE_ID="c37b3ebdc6c20a595b61308dd35837d4"

update_ddns() {
    local CF_API_TOKEN_PATH="$1"
    local RECORD_ID="$2"
    local DNS_NAME="$3"

    CF_API_TOKEN=$(cat "$CF_API_TOKEN_PATH")

    if [ -z "$RECORD_ID" ]; then
        echo "Usage: update_ddns <token_path> <record_id> <dns_name>"
        return 1
    fi
    if [ -z "$CF_API_TOKEN" ]; then
        echo "Cloudflare API token required."
        return 1
    fi

    # Get your current public IP
    local current_ip
    current_ip=$(curl -s https://api.ipify.org)
    if [ -z "$current_ip" ]; then
        echo "Could not fetch current IP."
        return 1
    fi

    # Query Cloudflare for the existing DNS record
    local cloudflare_ip
    cloudflare_ip=$(curl -s -X GET \
        "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" | jq -r '.result.content')

    if [ -z "$cloudflare_ip" ] || [ "$cloudflare_ip" = "null" ]; then
        echo "Could not fetch DNS record content from Cloudflare."
        return 1
    fi

    # Compare Cloudflare IP and current IP
    if [ "$current_ip" != "$cloudflare_ip" ]; then
        echo "IP changed (Cloudflare: $cloudflare_ip → Current: $current_ip). Updating..."
        curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
            -H "Authorization: Bearer $CF_API_TOKEN" \
            -H "Content-Type: application/json" \
            --data "{\"type\":\"A\",\"name\":\"$DNS_NAME\",\"content\":\"$current_ip\",\"proxied\":false}" \
            | jq .
    else
        echo "IP unchanged ($current_ip). No update needed."
    fi
}

update_ddns "$CF_API_TOKEN_PATH" "318ddaa36236b5d86906b3536543df13" "home.weewoo.dev"
