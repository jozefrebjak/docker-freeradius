FROM freeradius/freeradius-server:3.0.25

ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_USER=radius
ENV DB_PASS=radpass
ENV DB_NAME=radius
ENV RADIUS_KEY=testing123
ENV RAD_CLIENTS=10.0.0.0/24

# Copy configuration
COPY raddb/ /etc/raddb/

# Enable the sql & sqlcounter modules
RUN cd /etc/raddb/mods-enabled \
    && ln -s ../mods-available/sql sql \
    && ln -s ../mods-available/sqlcounter sqlcounter
