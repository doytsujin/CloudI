#!/bin/sh

# rebar is unable to separate the source directory path from
# the build directory path, so it is necessary to provide a directory
# structure that facilitates the autoconf/automake build directories when
# using rebar to build the source directories

REBAR_DIRS="\
    lib/cloudi_core \
    lib/cloudi_service_api_requests \
    lib/cloudi_service_db_mysql \
    lib/cloudi_service_db_pgsql \
    lib/cloudi_service_filesystem \
    lib/cloudi_service_http_client \
    lib/cloudi_service_http_cowboy \
    lib/cloudi_service_http_elli \
    lib/cloudi_service_http_rest \
    lib/cloudi_service_map_reduce \
    lib/cloudi_service_monitoring \
    lib/cloudi_service_oauth1 \
    lib/cloudi_service_queue \
    lib/cloudi_service_quorum \
    lib/cloudi_service_router \
    lib/cloudi_service_tcp \
    lib/cloudi_service_udp \
    lib/cloudi_service_validate \
    lib/cloudi_service_zeromq \
    external/cloudi_x_lager \
    external/cloudi_x_parse_trans \
    external/cloudi_x_bear \
    external/cloudi_x_cowboy \
    external/cloudi_x_cowlib \
    external/cloudi_x_elli \
    external/cloudi_x_emysql \
    external/cloudi_x_epgsql \
    external/cloudi_x_epgsql_wg \
    external/cloudi_x_exometer \
    external/cloudi_x_exometer_core \
    external/cloudi_x_folsom \
    external/cloudi_x_goldrush \
    external/cloudi_x_jsx \
    external/cloudi_x_msgpack \
    external/cloudi_x_nodefinder \
    external/cloudi_x_pgsql \
    external/cloudi_x_ranch \
    external/cloudi_x_setup \
    external/proper \
    lib/cgroups \
    lib/cpg \
    lib/erlang_term \
    lib/key2value \
    lib/keys1value \
    lib/pqueue \
    lib/quickrand \
    lib/reltool_util \
    lib/supool \
    lib/syslog_socket \
    lib/trie \
    lib/uuid \
    lib/varpool \
"

if [ $# -ne 3 ]; then
    echo "$0 create|destroy abs_top_srcdir abs_top_builddir"
    exit 1
fi
COMMAND=$1
abs_top_srcdir=$2
abs_top_builddir=$3

case $COMMAND in
    create)
        for d in $REBAR_DIRS; do
            application=`basename $d`
            if [ ! -d $abs_top_builddir/$d/ebin ]; then
                mkdir -p $abs_top_builddir/$d/ebin
            fi
            if [ ! -e $abs_top_srcdir/$d/ebin ]; then
                ln -s $abs_top_builddir/$d/ebin \
                      $abs_top_srcdir/$d/ebin
            fi
            if [ -d $abs_top_srcdir/$d/include -a \
                 ! -e $abs_top_builddir/$d/include ]; then
                ln -s $abs_top_srcdir/$d/include \
                      $abs_top_builddir/$d/include
            fi
            if [ -f $abs_top_builddir/$d/src/$application.app.src -a \
                 ! -e $abs_top_srcdir/$d/src/$application.app.src ]; then
                ln -s $abs_top_builddir/$d/src/$application.app.src \
                      $abs_top_srcdir/$d/src/$application.app.src
            fi
        done
        ;;
    destroy)
        for d in $REBAR_DIRS; do
            application=`basename $d`
            if [ -d $abs_top_builddir/$d/ebin ]; then
                rm -f $abs_top_builddir/$d/ebin/*
                rmdir $abs_top_builddir/$d/ebin
            fi
            if [ -h $abs_top_srcdir/$d/ebin ]; then
                rm -f $abs_top_srcdir/$d/ebin
            fi
            if [ -h $abs_top_builddir/$d/include ]; then
                rm -f $abs_top_builddir/$d/include
            fi
            if [ -h $abs_top_srcdir/$d/src/$application.app.src ]; then
                rm -f $abs_top_srcdir/$d/src/$application.app.src
            fi
        done
        ;;
    *)
        echo "command invalid: $COMMAND"
        exit 1
        ;;
esac

