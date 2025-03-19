package com.onlyboost.onlyboost

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform