local Pipeline = {
  kind: "pipeline",
  name: "example-pipeline",
  steps: [
    {
      detach: true,
      name: "database",
      type: "service",
      image: "postgres:11-alpine",
      ports: [
        5432,
      ],
      environment: {
        "POSTGRES_USER": "postgres",
        "POSTGRES_DB": "sample"
      }
    },
    {
      name: "lint dockerfile",
      image: "hadolint/hadolint:v1.16.3-debian",
      commands: [
        "hadolint Dockerfile"
      ]
    },
    {
      name: "clone submodule files",
      image: "alpine/git",
      commands: [
        "git submodule init",
        "git submodule update"
      ],
    },
    {
      name: "init database",
      image: "postgres:11-alpine",
      commands: [
        "sleep 8",
        "cd database_schema/",
        "psql -U sample-user -d sample -h database -f ./main.sql",
        "cd ../"
      ],
    },
    {
      name: "lint and test python functions",
      image: "python:3.7.3-slim",
      environment: {
        "APP_SETTINGS": "testing",
        "DB_URL": {
          "from_secret": "DB_URL"
        },
      },
      commands: [
        "make init",
        "make lint",
        "make test"
      ],
    },
    {
      name: "create ECR Repo",
      image: "hashicorp/terraform:latest",
      commands:[
        "cd ./terraform",
        "terraform init",
        "terraform plan",
        "terraform apply -auto-approve"
      ]
    },
    {
      name: "publish Dev Docker image",
      image: "plugins/ecr",
      settings: {
        repo: "<example-group/example-project>",
        registry: "<example.dkr.ecr.us-east-2.amazonaws.com>",
        region: "us-east-2",
        tags: [
          "dev"
        ],
      },
      when: {
        branch: [
          "dev"
        ],
      },
    },
    {
      name: "publish Prod Docker image",
      image: "plugins/ecr",
      settings: {
        repo: "<example-group/example-project>",
        registry: "<example.dkr.ecr.us-east-2.amazonaws.com>",
        region: "us-east-2",
        tags: [
          "0.0.1",
          "latest"
        ],
      },
      when: {
        branch: [
          "master"
        ],
      },
    },
    {
      name: "trigger",
      image: "plugins/downstream",
      settings: {
	      server: "<https://ci.example.io>",
	      token: {
          "from_secret": "drone_token"
        },
	      fork: "true",
	      repositories: [
          "<example/infrastruture@master>"
        ],
      },
    },
    {
      name: "notify slack",
      image: "plugins/slack",
      pull: "always",
      settings: {
	      webhook: {
         "from_secret": "slack_webhook"
        },
	      channel: "cicd",
      },
      when: {
	      status: [ "success", "failure" ],
      },
    },
    {
      name: " publish version.json to S3",
      image: "",
      commands: [
        "aws s3 cp version.json <s3://component-version/example-project.json>"
      ]
    }
  ]
};


[
  Pipeline
]
