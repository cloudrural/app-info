FROM adoptopenjdk:11-jdk-hotspot

# Environment variables required for this build
# ---------------------------------------------
ENV APP_HOME=/opt/app \
    APP_BIN_DIR=$CATALINA_HOME/bin \
    RUN_FILE=runApp.sh


RUN mkdir $APP_HOME

COPY install/ $APP_HOME/

EXPOSE 8080

WORKDIR $APP_HOME

# Define default command to start APP
# ------------------------------------
CMD exec $APP_HOME/$RUN_FILE





