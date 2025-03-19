package com.onlyboost.onlyboost

object EnvironmentConfiguration {
    enum class Types {
        dev, prod
    }

    val environmentType = EnvironmentConfiguration.Types.dev
    val host = "http://192.168.1.151"
    var callbackOrigin = "http://localhost:3149"
    val apiOrigin = "$host:3149"
    val frontendHost = "$host:5173"
}