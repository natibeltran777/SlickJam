shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : source_color, hint_depth_texture;

uniform float depth_range:hint_range(0.1, 100.0, 0.1);


uniform float steps_per_color = 2.;
uniform float pixel_size : hint_range(0.0,100.0,2.0) = 8.0;

void vertex(){
	//POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	
	//vec3 screen_color_0 = texture(SCREEN_TEXTURE, uv).rgb;
	//vec3 screen_color_1 = texture(SCREEN_TEXTURE, uv + vec2(-pixel_neighbor_distance, 0)).rgb;
	//vec3 screen_color_2 = texture(SCREEN_TEXTURE, uv + vec2(0, pixel_neighbor_distance)).rgb;
	//vec3 screen_color_3 = texture(SCREEN_TEXTURE, uv + vec2(0, -pixel_neighbor_distance)).rgb;
	//vec3 screen_color_4 = texture(SCREEN_TEXTURE, uv + vec2(pixel_neighbor_distance, 0)).rgb;
	
	//vec3 aggregate_color = (screen_color_0 + screen_color_1 + screen_color_2 + screen_color_3 + screen_color_4);
	
	//vec3 screen_color_4 = texture(SCREEN_TEXTURE, uv + vec2(pixel_neighbor_distance, 0)).rgb;
	//vec3 screen_color_0 = texture(SCREEN_TEXTURE, uv + vec2(pixel_neighbor_distance, 0)).rgb;
	
	
	
	vec3 normal = texture(NORMAL_TEXTURE, uv).rgb;
	float roughness =  texture(NORMAL_TEXTURE, uv).w;
	
	vec2 tex_size = vec2(textureSize(SCREEN_TEXTURE,0));
	vec2 pixel_count = tex_size/pixel_size;
	vec2 pixelated_uv = floor(SCREEN_UV * pixel_count) / pixel_count;
	vec4 color = texture(SCREEN_TEXTURE, pixelated_uv);
	ALBEDO = color.rgb;
	// your code goes here!
	
	
	// example outputs
	
	//ALBEDO = vec3(linear_depth); 	// showing depth texture
	//ALBEDO = normal; 				// showing normal texture
	//ALBEDO = vec3(roughness); 	// showing roughness texture
	//ALBEDO = aggregate_color*.2;		// showing screen texture
}