require "socket"

class UdpStreamer
  MSG_SIZE = 4096

  def initialize(host, port)
    @quit = false
    @client = UDPSocket.new
    @client.connect(host, port)
  end

  def run
    spawn do
      message = Bytes.new(MSG_SIZE)
      while @quit == false
        count = ARGF.read(message)
        @client.write(message)
        Fiber.yield
      end
    end
  end

  def exit
    @quit = true
    @client.close
  end
end

HOST = "localhost"
PORT = 18080
udp = UdpStreamer.new(HOST, PORT)
udp.run
sleep
