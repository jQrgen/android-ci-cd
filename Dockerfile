FROM openjdk:8-jdk

# Just matched `app/build.gradle`
ENV ANDROID_COMPILE_SDK "29"
# Just matched `app/build.gradle`
ENV ANDROID_BUILD_TOOLS "29.0.2"
# Version from https://developer.android.com/studio/releases/sdk-tools
ENV ANDROID_SDK_TOOLS "4333796"

ENV ANDROID_HOME /android-sdk-linux
ENV PATH="${PATH}:${ANDROID_HOME}/platform-tools/"
ENV FIREBASE_HOME = /firebase

# install OS packages
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 build-essential ruby ruby-dev
# We use this for xxd hex->binary
RUN apt-get --quiet install --yes vim-common
# install Android SDK
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN unzip -d $ANDROID_HOME android-sdk.zip
RUN rm android-sdk.zip

# Accept SDK lisences.
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}"
RUN echo y | $SDK_PATH/android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null
RUN echo y | $SDK_PATH/android-sdk-linux/tools/bin/sdkmanager "platform-tools" >/dev/null
RUN echo y | $SDK_PATH/android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null
RUN gem install fastlane -NV

# Firebase-tools setup
RUN wget https://github.com/firebase/firebase-tools/releases/download/v7.16.2/firebase-tools-linux firebase-tools-linux
RUN chmod +x firebase-tools-linux

#RUN wget --output-document=firebase-tools https://firebase.tools/bin/linux/latest
#RUN chmod +x ./firebase-tools

#RUN curl -sL https://firebase.tools | bash
#ADD https://github.com/firebase/firebase-tools/releases/download/v7.3.1/firebase-tools-linux firebase-tools
#RUN chmod +x firebase-tools

# RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager --licenses
# RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager update sdk --no-ui --all --filter platform-tools
# RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager  --silent update sdk --no-ui --all --filter build-tools-${ANDROID_BUILD_TOOLS}
# RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager  --silent update sdk --no-ui --all --filter extra-android-m2repository
# RUN echo y | android-sdk-linux/tools/bin/sdkmanager  --silent update sdk --no-ui --all --filter extra-google-google_play_services
# RUN echo y | android-sdk-linux/tools/bin/sdkmanager  --silent update sdk --no-ui --all --filter extra-google-m2repository
# RUN mkdir -p "${ANDROID_HOME}/licenses"
# RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "${ANDROID_HOME}/licenses/android-sdk-license"
# RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "${ANDROID_HOME}/licenses/android-sdk-preview-license"
# RUN echo -e "\nd975f751698a77b662f1254ddbeed3901e976f5a" > "${ANDROID_HOME}/licenses/intel-android-extra-license"
# install Fastlane
# COPY Gemfile.lock .
# COPY Gemfile .
# RUN gem install bundle
# RUN bundle install
