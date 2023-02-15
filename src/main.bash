main() {
  if (( $# == 0 )); then usage; exit 0; fi

  case "$1" in
    -c)
      do_make "$2"
      ;;

    -h|--help)
      usage
      ;;

    --version)
      echo "$VERSION"
      ;;

    *)
      echo "Invalid option '$1'." >&2
      exit 2
      ;;
  esac
}
