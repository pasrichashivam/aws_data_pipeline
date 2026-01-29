def call(String env) {
    def envConfig = [
        develop: [
            ENVIRONMENT: 'dev'
        ],
        production: [
            ENVIRONMENT: 'pro'
        ]
    ]

    if (!envConfig.containsKey(env)) {
        error "Unknown environment: ${env}"
    }

    envConfig[env].each { k, v ->
        env."${k}" = v
    }
}
