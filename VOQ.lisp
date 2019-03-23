(entity VOQ
	((data-av in)
	 (data in 144)
	 (data-rd out)
	 (output-port in 8)
	 (output-port-valid in)
	 (virt-queue out nx144)
	 (virt-queue-rd in n)) ;; optional
	(architecture () ()))

- send packet at exp or buf data to the port mentioned at the output-port,
  as soon as the av is high. once sent, make the corresponding rd high.
