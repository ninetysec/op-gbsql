DROP FUNCTION IF EXISTS dblink_disconnect_all();
CREATE OR REPLACE FUNCTION dblink_disconnect_all()
RETURNS TEXT as $$

DECLARE
linkname TEXT;

BEGIN

  FOR linkname IN ( SELECT unnest(dblink_get_connections()) )
  LOOP
    RAISE NOTICE 'Disconnect DBLink : %', linkname;
    PERFORM dblink_disconnect(linkname);
  END LOOP;

  RETURN 'OK';

END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION dblink_disconnect_all()
IS 'Leisure-断开所有dblink连接';
