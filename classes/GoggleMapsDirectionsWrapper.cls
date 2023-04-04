public class GoggleMapsDirectionsWrapper {
    public List<Routes> routes;
    public String status;
    public class Legs {
        public Distance distance;
        public Distance duration;
        public String end_address;
        public String start_address;
        public List<Steps> steps;
    }
    public class Routes {
        public List<Legs> legs;
    }
    
    public class Steps {
      public Distance distance;
      public Distance duration;
      public String travel_mode;
      public String maneuver;
      
   }
    
    public class Distance {
        public String text;
        public Integer value;
    }
    
}