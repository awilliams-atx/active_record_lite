# NB: Below is an example of how to use Rowboat to use Rowboat to write a seed file. Deleting this file entirely has no effect on the rest of the ORM.

Dir[File.dirname(__FILE__) + '../models/*.rb'].each {|file| require file }
