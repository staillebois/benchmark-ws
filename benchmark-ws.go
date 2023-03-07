package main

import (
	"log"

	"benchmark-ws/controllers"
	_ "benchmark-ws/docs"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

// @title Benchmark-ws API
// @version 1.0
// @description Online documentation for the benchmark-ws API.
// @BasePath /
// @schemes http https
func main() {
	r := gin.New()
	url := ginSwagger.URL("http://localhost:1323/swagger/doc.json")
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler, url))
	r.GET("/healthcheck", controllers.HealthCheck)

	if err := r.Run(":1323"); err != nil {
		log.Fatal(err)
	}
}
