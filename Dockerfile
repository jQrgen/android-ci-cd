FROM openjdk:8-jdk

# Just matched `app/build.gradle`
ENV ANDROID_COMPILE_SDK "29"
# Just matched `app/build.gradle`
ENV ANDROID_BUILD_TOOLS "29.0.2"
# Version from https://developer.android.com/studio/releases/sdk-tools
ENV ANDROID_SDK_TOOLS "4333796"

ENV ANDROID_HOME /android-sdk-linux
ENV PATH="${PATH}:/android-sdk-linux/platform-tools/"

# install OS packages
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 build-essential ruby ruby-dev
# We use this for xxd hex->binary
RUN apt-get --quiet install --yes vim-common
# install Android SDK
# RUN wget --quiet --output-document=android-sdk.tgz https://dl.google.com/android/android-sdk_r${ANDROID_SDK_TOOLS}-linux.tgz
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN unzip -d $ANDROID_HOME android-sdk.zip
RUN echo y | $SDK_PATH/android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null
RUN echo y | $SDK_PATH/android-sdk-linux/tools/bin/sdkmanager "platform-tools" >/dev/null
RUN echo y | $SDK_PATH/android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null
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
RUN gem install bundle
# RUN bundle install
