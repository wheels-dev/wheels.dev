<h1>CFWheels bCrypt</h1>
<p>CFWheels 2.x plugin helper methods for the bCrypt Java Lib</p>
<p>Note, this plugin requires CFWheels 2.x due to the automatic java mapping</p>
<h3>Usage</h3>

<h4>Encrypt a password</h4>
<pre>
	password = "CatzAreBetterThanDogz";

	// Hash a password for the first time
	hashedPassword   = bCryptHashPW(password, bCryptGenSalt());

	// With different complexity:
	// gensalt's log_rounds parameter determines the complexity
	// the work factor is 2**log_rounds, and the default is 10
	hashedPassword   = bCryptHashPW(password, bCryptGenSalt(12));
</pre>

<h4>Compared hashed password</h4>
<pre>

	// Check that an unencrypted password matches one that has
	// previously been hashed
	result = bCryptCheckPW(candidate,hashed);
</pre>
