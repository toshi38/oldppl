using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Schema;

namespace Murata
{
    class Program
    {
        static string output = "";
        static int peakFound = 0;
        static int[] peak = new int[3];
        static float maxLimit = 10;
        static float minLimit = 0;
        static float max = -9999;
        static int maxI = 0;
        static float maxDiff = 1000;
        static float dataLp = 512;
        static float k_lp1 = 1f / (2 ^ 8);
        static float k_lp2 = 1f / 32;
        static float dataHp = 1;
        static float dataFinal = 0;
        static int counter = 0;

        static void Main(string[] args)
        { 
            var client = new TcpClient("192.168.43.175", 8080);
            var nwStream = client.GetStream();

            while (!Console.KeyAvailable)
            {
                var bytesToRead = new byte[client.ReceiveBufferSize];
                var bytesRead = nwStream.Read(bytesToRead, 0, client.ReceiveBufferSize);
                var s = Encoding.ASCII.GetString(bytesToRead, 0, bytesRead);
                Cough(ConvertToInts(s.Split(',')).ToList());
            }
        }

        private static void Cough(List<int> data)
        {
            var lenData = data.Count;
            Console.WriteLine("Values: " + lenData);
            for (var i = 0; i < lenData; i++)
            {
                dataLp = k_lp1*(float)data[i] + (1 - k_lp1)*dataLp;
                dataHp = (float)data[i] - dataLp;
                dataFinal = k_lp2 * dataHp + (1 - k_lp2) * dataFinal;
                counter++;
                if (dataFinal > max)
                {
                    max = dataFinal;
                    maxI = counter;
                }
                else if ((max > maxLimit) && (dataFinal < minLimit))
                {
                    if (peakFound < 3)
                    {
                        peak[peakFound] = maxI;
                    }
                    else
                    {
                        peak[0] = peak[1];
                        peak[1] = peak[2];
                        peak[2] = maxI;

                        if (peak[1] - peak[0] < maxDiff && peak[2] - peak[1] < maxDiff)
                        {
                            Console.WriteLine("COUGH COUGH!!!!!");
                        }
                    }
                    max = -9999;
                    peakFound++;
                }
            }
        }

        private static IEnumerable<int> ConvertToInts(IEnumerable<string> values)
        {
            var data = values
                .Where(x => !string.IsNullOrEmpty(x))
                .Select(value => int.Parse(value, System.Globalization.NumberStyles.HexNumber));

            return data.Where(x => x != 0);
        }
    }
}
