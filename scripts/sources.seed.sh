#!/bin/bash
BASEDIR=$(dirname $0)
source $BASEDIR/sources.conf
[[ -f $BASEDIR/sources.local.conf ]] && source $BASEDIR/sources.local.conf

if [[ -z "$ARN_ROLE" ]]; then
	echo "ARN_ROLE must be defined in sources.local.conf!"
	exit 1
fi

echo "Creating $ARN_ROLE with account_id $ACCOUNT_ID org_id $ORG_ID"
IDENTITY=$($BASEDIR/identity_header.sh $ACCOUNT_ID $ORG_ID)

curl --location -g  --request POST "http://localhost:$PORT/api/sources/v3.1/bulk_create" \
--header "$IDENTITY" \
-d "$(cat <<EOF
{
  "sources": [
    {
      "name": "Amazon source",
      "source_type_name": "amazon",
      "app_creation_workflow": "manual_configuration"
    }
  ],
  "applications": [
    {
      "source_name": "Amazon source",
      "application_type_name": "provisioning"
    }
  ],
  "authentications": [
    {
      "resource_type": "Application",
      "resource_name": "provisioning",
      "username": "$ARN_ROLE",
      "authtype":"provisioning-arn"
    }
  ]
}
EOF
)"

curl --location -g  --request POST "http://localhost:$PORT/api/sources/v3.1/bulk_create" \
--header "$IDENTITY" \
-d "$(cat <<EOF
{
  "sources": [
    {
      "name": "Azure source",
      "source_type_name": "azure",
      "app_creation_workflow": "manual_configuration"
    }
  ],
  "applications": [
    {
      "source_name": "Azure source",
      "application_type_name": "provisioning"
    }
  ],
  "authentications": [
    {
      "resource_type": "Application",
      "resource_name": "provisioning",
      "username": "$SUBSCRIPTION_ID",
      "authtype":"provisioning_lighthouse_subscription_id"
    }
  ]
}
EOF
)"

curl --location -g  --request POST "http://localhost:$PORT/api/sources/v3.1/bulk_create" \
--header "$IDENTITY" \
-d "$(cat <<EOF
{
  "sources": [
    {
      "name": "Google source",
      "source_type_name": "google",
      "app_creation_workflow": "manual_configuration"
    }
  ],
  "applications": [
    {
      "source_name": "Google source",
      "application_type_name": "provisioning"
    }
  ],
  "authentications": [
    {
      "resource_type": "Application",
      "resource_name": "provisioning",
      "username": "$PROJECT_ID",
      "authtype":"provisioning_project_id"
    }
  ]
}
EOF
)"
