package com.onlyboost.onlyboost

import com.onlyboost.onlyboost.EnvironmentConfiguration.host

class Networking {
    enum class Providers {
        google,
        microsoft,
        apple
    }

    object Paths {
        fun authEntryPoint(provider: Networking.Providers): String {
            return "${EnvironmentConfiguration.apiOrigin}/auth/$provider"
        }

        fun notFound(): String {
            return "${EnvironmentConfiguration.frontendHost}/notFound"
        }

        fun authorizationSuccessStart(): String {
            return "${EnvironmentConfiguration.frontendHost}/auth/success?sessionToken"
        }

        fun authorizationFailureStart(): String {
            return "${EnvironmentConfiguration.frontendHost}/auth/failure"
        }
    }
}