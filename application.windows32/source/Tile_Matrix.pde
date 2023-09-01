
// person( int identity_ , PVector start_pos_ , color dcolour_ , int up_ , int down_ , int left_ , int right_ , int speedup_ ){

person[] people = new person[4];
boolean[] in_matrix =  new boolean[people.length]; //true means in matrix, false means out of matrix

ArrayList<person> p_in_matrix;

matrix m;

gameMode game;

artMode art;
 
void setup(){
    // size( 1200 , 600 );
     fullScreen();
    // matrix m = new matrix ( new PVector( width/2 , height /2 ) , 400 , 400 );
    smooth();
    frameRate(30);

    people[0] = new person ( 0 , new PVector( width / 4 , height/4 ) , color( 255 , 0 , 89 ) , 38 , 40 , 37 , 39 , 17 ); 
    // 38 -- Up
    // 40 -- Down
    // 37 -- Left
    // 39 -- Right
    // 17 -- Ctrl

    people[1] = new person ( 1 , new PVector( (0.75) * width ,  height / 4 ) , color( 0 , 122 , 255 ) , 87 , 83 , 65 , 68 , 81 ); 
    // 87 -- W
    // 83 -- S
    // 65 -- A
    // 68 -- D
    // 81 -- Q

    people[2] = new person ( 2 , new PVector( (0.75) * width , (0.75) * height ) , color( 182 , 0 , 255 ) , 89 , 72 , 71 , 74 , 84 ); 
    // 89 -- Y
    // 72 -- H
    // 71 -- G
    // 74 -- J
    // 84 -- T

    people[3] = new person ( 3 , new PVector( width / 4  , (0.75) * height ) , color( 255 , 188 , 0 ) , 80 , 59 , 76 , 222 , 79 ); 
    // 80 -- P
    // 186 -- ;
    // 76 -- l
    // 222 -- '
    // 79 -- O

    p_in_matrix = new ArrayList<person>();

    in_matrix[0] = false;
    in_matrix[1] = false;
    // matrix( PVector center_ , int length_ , person[] guys_ ){
    m = new matrix ( new PVector( width/2 , height/2 ) , 0.8 * height , people);

    game = new gameMode ( new PVector( 10 , 60) , 10 , 0.8 , m );
    // gameMode( PVector bat_size_ , float pong_size_ , float boundary_ratio_ , matrix m_g , person[] gamers_ ){

    art = new artMode( 5 , m );
    // artMode( int trail_size_ , matrix m_a_ ){
}


void draw(){

    colorMode( RGB , 255 , 255 , 255 );
    background(100);
    boolean[] matrix_mode = new boolean[2];

    matrix_mode = m.flow( );

    boolean p = m.matrix_occupied();
    // println( matrix_mode[0] , matrix_mode[1] );
    for ( int i = 0 ; i < people.length ; i ++ ){ //updates position of all people
        people[i].move();
    }

    if ( m.matrix_occupied() != p ){

        if ( m.matrix_occupied() ){  // a person reentered the matrix
            //start new everything
            game.playing = false;
            
            art.trail.clear();
            art.trail_identity.clear();
            art.trail_hue.clear();

            art.drawing = false;

        }
        else{ //a person left the matrix

            art.drawing = true; 
        }        
    }


    for ( int i = people.length-1 ; i >= 0 ; i -- ){

        if( just_stepped( people[i].pos , people[i].prev_position , m.top_left , new PVector( m.length , m.length )  ) ) {

            p_in_matrix.add( people[i] );

        }

        else if ( just_stepped( people[i].prev_position , people[i].pos , m.top_left , new PVector( m.length , m.length )  ) ) {

            //checks which person is it that left the matrix
            for ( int j = p_in_matrix.size() - 1 ; j >= 0 ; j -- ){

                person pe = p_in_matrix.get( j );
                if ( pe.identity == people[i].identity ){
                    p_in_matrix.remove( j ) ;
                    continue;
                }
            }
        }


        // boolean just_stepped ( PVector position ,  PVector prev_position , PVector boundary , PVector boundary_size ){
    }


    // if ( matrix_mode[0] && p_in_matrix.size() != 0 ){

    if ( m.matrix_occupied() ){

        if ( matrix_mode[1]  ){
            //art mode
            // clip( m.top_left.x , m.top_left.y , m.length , m.length );
            colorMode( HSB , 360 , 100 , 100 );
            // colorMode( RGB , 255 , 255 , 255 );
            art.run( p_in_matrix );
            // println("artmode" );
        }
        else {

            // noClip();
            //game mode
            // print("game");
            colorMode( RGB , 255 , 255 , 255 );
            game.run( p_in_matrix );

            art.trail.clear();
            art.trail_identity.clear();
            art.trail_hue.clear();

        }
    }

    else if ( art.drawing ) {
        colorMode( HSB , 360 , 100 , 100 );
        art.run( p_in_matrix );
    }

    for ( int i = 0 ; i < people.length ; i ++ ){
        people[i].display();
    }

}


class person{
    // PVector start_pos;

    int identity ; 
    PVector pos;
    PVector vel;
    PVector prev_position;
    int control_keys[] = new int[5];
    boolean control_key_pressed[] = new boolean[5];
    PVector direction; 

    color dcolour;

    float speed;

    person( int identity_ , PVector start_pos_ , color dcolour_ , int up_ , int down_ , int left_ , int right_ , int speedup_ ){
    // person( PVector start_pos_ , color dcolour_ , int up_ , int down_ , int left_ , int right_ , int speedup_ ){

        identity = identity_ ; 
        pos = new PVector ( start_pos_.x , start_pos_.y );
        prev_position = new PVector ( 0 , 0 );
        dcolour = dcolour_;
        control_keys[0] = up_;
        control_keys[1] = down_;
        control_keys[2] = left_;
        control_keys[3] = right_;
        control_keys[4] = speedup_;
        control_key_pressed[0] = false;
        control_key_pressed[1] = false;
        control_key_pressed[2] = false;
        control_key_pressed[3] = false;
        control_key_pressed[4] = false;
        vel = new PVector ( 0 , 0 );
        direction = new PVector ( 0 , 0 ); 
        speed = 0 ;
        
    }

    void key_sync( int kCode ){
        if ( kCode == this.control_keys[0] ){
            this.control_key_pressed[0] = true;
        }
        else if ( kCode == this.control_keys[1] ){
            this.control_key_pressed[1] = true;
        }
        else if ( kCode == this.control_keys[2] ){
            this.control_key_pressed[2] = true;
        }
        else if ( kCode == this.control_keys[3] ){
            this.control_key_pressed[3] = true;
        }
        else if ( kCode == this.control_keys[4] ){
            this.control_key_pressed[4] = true;
        }

        
        // for ( int i = 0 ; i < control_key_pressed.length ; i ++){
        //     println( control_key_pressed[i]); 
        //     println( control_keys[i] );
        // }

    }

    void key_unsync( int kCode ){
        if ( kCode == this.control_keys[0] ){
            this.control_key_pressed[0] = false;
        }
        else if ( kCode == this.control_keys[1] ){
            this.control_key_pressed[1] = false;
        }
        else if ( kCode == this.control_keys[2] ){
            this.control_key_pressed[2] = false;
        }
        else if ( kCode == this.control_keys[3] ){
            this.control_key_pressed[3] = false;
        }
        else if ( kCode == this.control_keys[4] ){
            this.control_key_pressed[4] = false;
        }

    }

    void move(){
        // float speed; 

        if ( control_key_pressed[0] == true ){
            direction.y = -1 ; 
        }
        if ( control_key_pressed[1] == true ){
            direction.y = 1 ; 
        }
        if ( control_key_pressed[2] == true ){
            direction.x = -1 ; 
        }
        if ( control_key_pressed[3] == true ){
            direction.x = 1 ; 
        }

        if ( (control_key_pressed[0] || control_key_pressed[1] || control_key_pressed[2] || control_key_pressed[3] ) == false )  {
            speed = 0 ;
        }

        if ( control_key_pressed[4] == true ){
            if( speed <= 8){
                speed += 1;
            } 
        }
        else{
            if ( speed <= 5 ){
                speed += 0.5 ;
            }
            else {
                speed = 5 ; 
            }
        }

        vel = direction.mult(speed); 
        prev_position.set(pos); 
        pos.add(vel); 
        vel.mult(0);
        
    }

    void display(){

        fill(dcolour);
        // noStroke();
        stroke(0);
        strokeWeight(1);
        circle( pos.x , pos.y , 10 );
        // noStroke();
    }


}


void keyPressed() {


    // personB.key_sync(keyCode);
    // personA.key_sync(keyCode);

    for ( int i = 0 ; i < people.length ; i ++ ){
        people[i].key_sync(keyCode); 
    }

    // println(keyCode);
}

void keyReleased() {

    // personB.key_unsync(keyCode);
    // personA.key_unsync(keyCode);      
    for ( int i = 0 ; i < people.length ; i ++ ){
        people[i].key_unsync(keyCode); 
    }
}


class matrix{


    boolean state; // ON/OFF
    boolean mode; // true = art mode, false = game mode

    PVector center;
    float length;

    PVector top_left;
    PVector btm_right;

    person[] guys;

    PVector[] control_tile = new PVector[2];
    float tile_size;

    boolean[] toggle_switch = new boolean[2]; 
    // toggle_switch[0] is true if matrix_occupied()
    // toggle_switch[1]: true (Art Mode), false (Game Mode)

    matrix( PVector center_ , float length_ , person[] guys_ ){
        center = center_;
        length = length_;
        top_left = new PVector ( center.x - length/2 , center.y - length/2 );
        btm_right = new PVector ( center.x + length/2 , center.y + length/2 );
        guys = guys_;

        tile_size = length/30;

        control_tile[0] = new PVector ( 0 , 0 );
        control_tile[1] = new PVector ( 0 , 0 );

        control_tile[0].set( top_left );
        control_tile[1].set( btm_right.x-tile_size , btm_right.y-tile_size );

        toggle_switch[0] = false;
        toggle_switch[1] = true;
    }

    boolean[] flow (){// mainly to compute when the matrix will toggle the modes
    // void flow(){


        fill(50);
        noStroke();
        rect( top_left.x , top_left.y , length, length );

        fill( 255 , 103 , 202 ); //pink colour
        for ( int i = 0 ; i < control_tile.length ; i ++ ){
            square( control_tile[i].x , control_tile[i].y , tile_size );
        }


        // PVector[] tem = new PVector[guys.length];
        // for ( int i = 0 ; i < tem.length ; i ++){
        //     tem[i] = new PVector( 0 , 0 );
        // }
        toggle_switch[0] = matrix_occupied(); 
        if ( matrix_occupied() ){

            // if person 1 person just stepped on the control tiles, and both control tiles are being stepped on

            boolean[] check_tiles = new boolean[ control_tile.length ]; // a list of bool to see if each control_tile is stepped
            for ( int o = 0 ; o < check_tiles.length ; o ++ ){
                check_tiles[o] = false;
            }

            // println( guys );
            // println( control_tile ); 
            // println( new PVector ( tile_size , tile_size ) ) ;

            for ( int i = 0 ; i  < control_tile.length ; i ++ ){ //for each tile

                for ( int j = 0 ; j < guys.length ; j ++ ){
                    if ( within( guys[j].pos , control_tile[i] , new PVector( tile_size , tile_size ) ) == true ){
                        check_tiles[i] = true;
                    }
                    // boolean within ( PVetor aPoint , PVector topleftB , PVector boundary ){
                }

            }

            boolean all_check = true;
            for ( int i = 0 ; i < check_tiles.length ; i ++ ){
                if ( check_tiles[i] == false ){
                    all_check = false; //as long one value in check_tiles is false, all_check is false
                } 
            }
            // println( check_tiles );

            boolean stepped = false ; 

            for ( int j = 0 ; j < control_tile.length ; j ++ ){
                
                for ( int i = 0 ; i < guys.length ; i ++ ){
                    if ( just_stepped ( guys[i].pos , guys[i].prev_position , control_tile[j], new PVector ( tile_size , tile_size ) ) ) {
                        stepped = true ; 
                    }                    
                } 

            }

            if ( all_check && stepped ){ // toggle control tile

                // toggle_switch[1] = false;

                if ( toggle_switch[1] ){
                    toggle_switch[1] = false;
                }
                else{
                    toggle_switch[1] = true;
                }
                // println( " toggle " ); 
            }
        }

        else{
            toggle_switch[ 1 ] = true ; 
        }

        return toggle_switch ; 
    }

    boolean matrix_occupied (){
        boolean return_bool = false;
        for ( int i = 0 ; i < guys.length ; i ++){

            PVector loc = guys[i].pos; 

            if ( loc.x < btm_right.x && loc.x > top_left.x && loc.y < btm_right.y && loc.y > top_left.y ){
                return_bool = true; 
                continue;
            }
        }

        return return_bool;

    }

    // boolean just_stepped ( PVector position ,  PVector prev_position , PVector boundary , PVector boundary_size ){

    //         // if position is within tile
    //         //prev_position out of tile

    //         boolean v = false ; 

    //         if ( within( position , boundary , boundary_size ) == true ){
    //             if ( within( prev_position , boundary , boundary_size ) == false ){

    //                 v = true; 

    //             }   
    //         }

    //         return v ; 

    // }

    boolean toggleperson ( person yoz ){
        
        boolean toggle = false ;

        if ( just_stepped( yoz.pos , yoz.prev_position ,  top_left , new PVector( length , length ))){ //stepped in 
            
            toggle = true;

        }

        else if ( just_stepped( yoz.prev_position , yoz.pos ,  top_left , new PVector( length , length ))){//stepped out
            
            toggle = true;
        
        }

        return toggle ; 
    }

    
}


class gameMode{

    PVector bat_size;
    PVector[] bats ; 
    PVector pong = new PVector( 0 , 0 );
    PVector pong_vel = new PVector ( 0 , 0 );
    float pong_size ; 

    float boundary_ratio ; 
    PVector boundary_topleft ;
    float boundary_width;
    float boundary_length;

    matrix m_g ; 
    person[] gamers ; 

    boolean playing = false ; 

    float theta = 0 ;
    float alpha = 0 ;
    // gameMode( PVector bat_size_ , float pong_size_ , float boundary_ratio_ , matrix m_g , person[] gamers_ ){
    gameMode( PVector bat_size_ , float pong_size_ , float boundary_ratio_ , matrix m_g_ ){
        
        m_g = m_g_ ; 

        bat_size = bat_size_;

        pong_size = pong_size_ ;

        boundary_ratio = boundary_ratio_;

        boundary_length = m_g.length ; 
        boundary_width = boundary_ratio * m_g.length ; 

        boundary_topleft = m_g.top_left.copy();
        boundary_topleft.y += 0.5 * ( 1 - boundary_ratio ) * boundary_length ; 

    }

    void run( ArrayList<person> gamers_ ){

        // gamers = new person[ gamers_.size() ];
        // person[] arraylist_to_list( ArrayList<person> als ){
        
        gamers = new person[ gamers_.size() ];
        gamers = arraylist_to_list( gamers_ );

        // gamers = gamers_ ; 

        bats = new PVector[ gamers.length ];
        for ( int i = 0 ; i < bats.length ; i ++ ){

            bats[i] = new PVector( gamers[i].pos.x - bat_size.x / 2 , gamers[i].pos.y - bat_size.y / 2 ) ;
        }

        // rect( gamers[i].pos.x - bat_size.x / 2 , gamers[i].pos.y - bat_size.y / 2 , bat_size.x , bat_size.y )
        
        fill( 137 , 148 , 170 );
        rect( boundary_topleft.x , boundary_topleft.y , boundary_length , boundary_width ) ; 

        for ( int i = 0 ; i < gamers.length ; i ++ ){

            fill ( 0 );
            rect( bats[i].x , bats[i].y , bat_size.x , bat_size.y );
        }

        if ( playing ){
            //continue game
            pong_move();
            // println( pong_vel );
        }
        else{
            //start new game
            new_game();
        }
        pong_display();

    }

    void new_game(){

        float start_vel = 6 ;
        pong.set ( boundary_topleft.x + boundary_length/2 , boundary_topleft.y + boundary_width/2 );
        float direction = random (2)  ;
        // println( direction );

        if ( direction > 1 ){
            direction = 1;
        }
        else {
            direction = -1;
        }

        theta = random ( PI/2 );
        // theta = radians( 130 );


        if ( theta < PI / 4 ){
            pong_vel.set( direction * start_vel * cos( theta ) , -start_vel * sin( theta ) );
        }
        
        else{
            theta = theta - PI / 4 ;
            pong_vel.set( direction * start_vel * cos(theta) , start_vel * sin( theta ) );
        }

        playing = true ; 

    }

    void pong_move(){

        pong.add( pong_vel );


        //if pong touches boundary , pong rebounds
        if ( pong.y - pong_size / 2 < boundary_topleft.y || pong.y + pong_size / 2 > boundary_topleft.y + boundary_width ){

            pong_vel.y = - pong_vel.y;
        }
        float d;
        float alpha;
        float k ;
        //if pong touches one of the player's bat, bong rebounds in opp x direction
        for ( int i = 0 ; i < gamers.length ; i++ ){

            if ( within( new PVector( pong.x + pong_size/2 , pong.y) , bats[i] , bat_size )){

                if( gamers[i].prev_position.x > pong.x && pong_vel.x > 0 ){ //pong is coming from the left

                    // pong_vel.x = - pong_vel.x ; //pong rebound in direction opp of normal

                    d = ( gamers[i].pos.y - pong.y ) / ( 0.5 * bat_size.y ) ;
                    k = map ( d , -1 , 1 , -radians(45) , radians(45) ) ;

                    theta = atan( pong_vel.y / - pong_vel.x );

                    // println( "theta" , degrees(theta) );
                    // println( "k" , degrees( k ) );


                    alpha = theta + k ;

                    // println( "alpha" , degrees( alpha ) ); 
                    pong_vel.mult(1.1);

                    pong_vel.set( - pong_vel.mag() * cos( alpha ) , -pong_vel.mag() * sin( alpha )  ) ;
 
                }
            }


            else if ( within( new PVector( pong.x - pong_size/2 , pong.y) , bats[i] , bat_size )){

                // print("right");

                if( gamers[i].prev_position.x < pong.x && pong_vel.x < 0 ){ //pong is coming from the right
                    // print("right");
                    // pong_vel.x = - pong_vel.x ; 

                    d = ( gamers[i].pos.y - pong.y ) / ( 0.5 * bat_size.y ) ;
                    k = map ( d , -1  , 1 , -radians(45) , radians(45) ) ;

                    theta = atan(  -pong_vel.y /  -pong_vel.x );

                    // println( "theta" , degrees(theta) );
                    // println( "k" , degrees( k ) );

                    alpha = theta + k ; 
                    println( "alpha" , degrees( alpha ) ); 
                    pong_vel.mult(1.1);

                    pong_vel.set(  pong_vel.mag() * cos( alpha ) , - pong_vel.mag() * sin( alpha )  ) ;
                }
            }
            
            // boolean within ( PVector aPoint , PVector topLeftB , PVector boundary ){
        }

        //if pong reaches end zone , new game
        boolean left_lose = pong.x - pong_size / 2 < boundary_topleft.x;
        boolean right_lose = pong.x + pong_size / 2 > boundary_topleft.x + boundary_length;

        if ( left_lose || right_lose ){
            
            playing = false ;// new game

            if ( left_lose ){//display left side blink red three times, right side blink green three times

            }

            else{//right_lose , display right side blink red three times, left side blink green three times

            }


            // }

        }


    }

    void pong_display(){
        
        fill ( 100 , 100 , 100 );
        circle( pong.x , pong.y , pong_size );

    }


}

class artMode{

    int trail_size;

    person[] artists = null ; 

    // person[] tem_artists ; 

    ArrayList<ArrayList<PVector>> trail = new ArrayList<ArrayList<PVector>>() ;

    IntList trail_identity = new IntList() ;  //has the same index correlation as trail

    FloatList trail_hue = new FloatList();

    // FloatList seed_s = new FloatList();
    // FloatList seed_b = new FloatList();

    // FloatList t_s =  new FloatList();
    // FloatList t_b = new FloatList();

    boolean dying = false ; 

    ArrayList<ArrayList<PVector>> dead_trail = new ArrayList<ArrayList<PVector>>() ;
    FloatList dead_trail_hue = new FloatList();

    boolean drawing = false ; 

    matrix m_a;

    artMode( int trail_size_ , matrix m_a_ ){
    // artMode( int trail_size_ ){

        trail_size = trail_size_; 
        m_a = m_a_;
    }

    void run( ArrayList<person> artists_ ){

        artists = new person[ artists_.size() ];

        artists = arraylist_to_list( artists_ );

        // println( artists.length );

        int path_size = 40;


        // if there are new artists in the matrix
        // new artist enters the matrix
        // matrix swithches from art mode to game mode
        if ( artists.length > trail.size() ){

            //newly added artists are always at the end of artists[] 
            //starts from the last position in trail and ends at the artists.length, so it appends to the array, until it reaches the number of artists in it
            for ( int i = trail.size()  ; i < artists.length ; i ++ ){ 
                                
                ArrayList<PVector> empty_path = new ArrayList<PVector>();
                trail.add( empty_path );
                trail_identity.append( artists[i].identity );

                float random_hue = 0;
                // boolean different_color = false ; 
                // while ( different_color == false ){
                while( true ){

                    random_hue = random( 360 );                  
                    if ( trail_hue.size() == 0 ){ // no trail previously
                        // different_color = true ;
                        break;
                    }  
                    boolean all = false;
                    for ( int j = 0 ; j < trail_hue.size() ; j ++) {

                        if ( abs( random_hue - trail_hue.get(j) ) < 30 ){
                            all = true ; 
                            continue;
                        }
                    }
                    if ( all == false ){
                        
                        // different_color = true ; 
                        break;
                    }
                }

                trail_hue.append( random_hue );

            }
        }

        //removes the trail everytime an artist leaves the matrix
        //the extra trail_identity value is the artist that left
        if ( dead() ){
            for( int i = trail_identity.size() - 1 ; i >= 0 ; i -- ){

                int iden = trail_identity.get( i );
                boolean bool = false ; 

                for( int j = 0 ; j < artists.length ; j ++ ){
                    if ( artists[j].identity == iden ){
                        bool = true ; //means that the artist has a identity in the trail
                        continue;
                    }
                }

                if ( bool == false ){ //means the artists[i] left the matrix 

                    dying = true ; // there is a dying trail

                    ArrayList<PVector> d_path = (ArrayList<PVector>) trail.get( i ).clone() ;
                    float d_hue = trail_hue.get( i ); 

                    trail_identity.remove( i );
                    trail.remove( i );
                    trail_hue.remove( i );

                    dead_trail.add( d_path );
                    dead_trail_hue.append( d_hue );

                }
            }
        }

        blendMode( LIGHTEST );
        strokeWeight( 10 );

        //updates dead trails and displays dead trails
        if ( dead() ){  

            // dead = true;
            
            for ( int i = dead_trail.size()-1 ; i >= 0  ; i -- ){

                ArrayList<PVector> d_path = (ArrayList<PVector>) dead_trail.get( i ).clone() ;
                //removes the past position in the dead path


                d_path.remove( 0 ); 
                if ( d_path.size() > 0 ){
                    d_path.remove( 0 );
                }


                // if there are still position in the dead path     
                if( d_path.size() > 0 ){ 
                    float d_hue = dead_trail_hue.get( i );

                    //updates value in dead trail
                    dead_trail.set( i , (ArrayList<PVector>)d_path.clone() );

                    for ( int j = 0 ; j < d_path.size()-1 ; j ++ ){      //displaying of dead path                   
                        PVector d_step = d_path.get( j ).copy();
                        PVector d_earlier_step = d_path.get( j + 1).copy();

                        stroke( d_hue , 80 , 80 );
                        kale( d_step , d_earlier_step );

                    }

                }

                //no more positions in dead path, remove index from the arrays
                else{ 

                    dead_trail.remove( i ); 
                    dead_trail_hue.remove( i );

                    }
                }
            }
            
            if ( dead_trail.size() == 0){ //no more dead trails
            dying = false ; 

            }


        // println( "trail size" , trail.size() );

        //checks for the artist that the trail_identity is associated to
        //if artist moves, adds new PVector into the associated path
        //sync and displays trails
        if ( trail.size() > 0){
            for ( int i = 0 ; i < trail.size() ; i ++ ){//for every trail

                // ArrayList<PVector> path = trail.get( i );
                ArrayList<PVector> new_path = (ArrayList<PVector>) trail.get( i ).clone() ;
                // path.clear();
                int index = 0 ; 

                //checks for all artists, which identity = trail identity
                for ( int j = 0 ; j < artists.length ; j ++ ){ 

                    int val = trail_identity.get( i ) ;

                    if ( artists[j].identity == val ){ //finds the index of the artist which the trail is correlated to

                        index = j ; // saves the index of the artist that which belongs to that trail
                        continue;

                    }
                }

                //if the artist moves, adds a step
                if( artists[index].pos.x != artists[index].prev_position.x || artists[index].pos.y != artists[index].prev_position.y ){
                    new_path.add( artists[index].pos.copy() );
                    // move colors
                }
                //artist stops moving but has a path behind, or when path size exceeds the max size, removes a step
                else if ( new_path.size() > 0 ) { 
    
                    new_path.remove( 0 );
                    // println( "remove line");
                    // new_path.remove( 0 );
                
                }
                if ( new_path.size() >= path_size ){
                    new_path.remove ( 0 );
                    // println( "remove line");
                }
                //

                float hue = trail_hue.get(i);
                //syncing and dispalying of path
                for ( int k = 0 ; k < new_path.size()-1  ; k ++ ){//goes from last index to second index (1)
                    // println(k);
                    PVector step = new_path.get( k ).copy();
                    PVector earlier_step = new_path.get( k+1 ).copy();
                    
                    stroke(hue , 80 , 80 );
                    kale( step , earlier_step );

                    new_path.set( k , earlier_step.copy() );// syncs the last step to the next step

                }

                trail.set( i , (ArrayList<PVector>)new_path.clone() );//updates the path (of 1 person) into trail
            }

        }
        
        blendMode(BLEND);

        //for troubleshooting
        // for ( int j = 0 ; j < trail.size() ; j ++ ){
            
        //     ArrayList<PVector> path = trail.get( j );
        //     // println( "path size" , j , path.size() );

        // }


    }

    void kale ( PVector previous_step , PVector step ){

        
        PVector new_step = new PVector ( step.x- m_a.center.x , step.y - m_a.center.y );
        PVector new_previous_step = new PVector( previous_step.x - m_a.center.x , previous_step.y - m_a.center.y );

        pushMatrix();
        translate( m_a.center.x , m_a.center.y );
        
        for ( int k = 0 ; k < 4 ; k ++ ){

            pushMatrix();

            rotate( k * TWO_PI/4 );
            line( new_step.x , new_step.y , new_previous_step.x , new_previous_step.y ) ;

                pushMatrix();
                scale( -1 , 1 );

                line( new_step.x , new_step.y , new_previous_step.x , new_previous_step.y ) ;
                
                popMatrix();

            
            popMatrix();
        }

        popMatrix();

    }

    boolean dead () { //returns true if there are dead trails
        boolean ret = false ; 
        // if there are more trails than artists in the matrix
        // or if there are dead trails that are dying

        // if ( artists != null  ){
            if ( trail.size() > artists.length || dying ){ 
                ret = true ; 
            }
        // }

        return ret ;
    }

}

boolean within ( PVector aPoint , PVector topLeftB , PVector boundary ){

    boolean b = false;
    if ( aPoint.x > topLeftB.x && aPoint.x < (topLeftB.x + boundary.x) ){
        if ( aPoint.y > topLeftB.y && aPoint.y < (topLeftB.y + boundary.y) ){
            b = true;
        }
    }

    return b;
}

boolean toggle ( boolean b ){
    if ( b == true ){
        return false ; 
    }
    else{
        return true ; 
    }
}

boolean just_stepped ( PVector position ,  PVector prev_position , PVector boundary , PVector boundary_size ){

    // if position is within tile
    //prev_position out of tile

    boolean v = false ; 

    if ( within( position , boundary , boundary_size ) == true ){
        if ( within( prev_position , boundary , boundary_size ) == false ){

            v = true; 

        }   
    }

    return v ; 

}


person[] arraylist_to_list( ArrayList<person> als ){

    person[] ret_list = new person[ als.size() ];

    for ( int i = 0 ; i < als.size() ; i ++ ){

        person index = als.get( i );
        ret_list[i] = index ; 

    }

    return ret_list ;

}
