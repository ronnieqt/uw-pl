#include <iostream>

class ChildA;
class ChildB;

class Base
{
public:
    virtual ~Base() {};
    virtual void act(Base& other) = 0;
    virtual void act_from(ChildA& src) = 0;
    virtual void act_from(ChildB& src) = 0;
};

class ChildA: public Base
{
public:
    void act(Base& other) override
    {
        // dispatch 2: use ChildB::act_on_a because other is a reference to a ChildB instance
        std::cout << "A's act method called" << std::endl;
        other.act_from(*this);
    }
    void act_from(ChildA& src) override
    {
        std::cout << "A act on A" << std::endl;
    }
    void act_from(ChildB& src) override
    {
        std::cout << "B act on A" << std::endl;
    }
};

class ChildB: public Base
{
public:
    void act(Base& other) override
    {
        std::cout << "B's act method called" << std::endl;
        other.act_from(*this);
    }
    void act_from(ChildA& src) override
    {
        std::cout << "A act on B" << std::endl;
    }
    void act_from(ChildB& src) override
    {
        std::cout << "B act on B" << std::endl;
    }
};

int main() 
{
    Base* ptr_to_a = new ChildA();
    Base* ptr_to_b = new ChildB();
    
    // dispatch 1: use ChildA::act(...) because ptr is pointing to a ChildA instance
    ptr_to_a->act(*ptr_to_b);
    ptr_to_a->act(*ptr_to_a);
    ptr_to_b->act(*ptr_to_b);
    ptr_to_b->act(*ptr_to_a);
    
    delete ptr_to_b;
    delete ptr_to_a;
    return 0;
}