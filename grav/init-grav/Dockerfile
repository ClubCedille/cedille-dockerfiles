# Use a base image that has necessary tools (e.g., wget, rsync)
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache wget unzip rsync

# Define Grav theme/skeleton URL
ARG GRAV_SKELETON_URL=https://github.com/getgrav/grav-skeleton-gateway-site/releases/download/1.0.1/grav-skeleton-gateway-site+admin-1.0.1.zip

# Download and unzip the theme
WORKDIR /initial-content
RUN wget "$GRAV_SKELETON_URL" -O theme.zip \
    && unzip theme.zip \
    && rm theme.zip

# Add and prepare the script to copy content if necessary
COPY copy-theme.sh /copy-theme.sh
RUN chmod +x /copy-theme.sh
ENTRYPOINT ["/copy-theme.sh"]
