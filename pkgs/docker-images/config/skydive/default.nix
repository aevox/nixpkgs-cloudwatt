{ pkgs }:

pkgs.writeTextFile {
  name = "skydive.yml.ctmpl";
  text = ''
    ws_pong_timeout: 5

    cache:
      expire: 300
      cleanup: 30

    analyzers:
      {{- range $index, $data := service "skydive-analyzer-pods" }}
      - {{ $data.Address }}:8082
      {{- end }}

    analyzer:
      listen: 0.0.0.0:8082
      topology:
        fabric:
          - TOR[Name=tor] -> TOR_PORT[Name=port]
          - TOR_PORT --> *[Type=host]/eth4
          - TOR_PORT --> *[Type=host]/eth5
      bandwidth_threshold: relative
      bandwidth_relative_active: 0.1
      bandwidth_relative_warning: 0.4
      bandwidth_relative_alert: 0.8

    graph:
      backend: memory

    auth:
      analyzer_username: admin
      analyzer_password: password

    logging:
      default: INFO
      topology/probes: INFO
      topology/graph: WARNING
      backends:
        - stdout
      encoder: json
      color: false

    etcd:
      max_wal_files: 5
      max_snap_files: 3
      data_dir: /tmp/skydive/etcd

      listen: 0.0.0.0:12379
      servers:
        - http://127.0.0.1:12379
      peers:
        {{- range $index, $data := service "skydive-analyzer-pods" }}
        - http://{{ $data.Address }}:12379
        {{- end }}
  '';
}
